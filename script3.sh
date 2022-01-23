#Εργαστήριο ΛΣ 1 / Ασκηση 2 / 2022 
#Ονοματεπώνυμο: Δημήτριος  Θεοδωρόπουλος
#ΑΜ: ice20390073
#
# Ερώτηση 3
#Να γραφτεί script με το όνομα cmpdir το οποίο να συγκρίνει τα περιεχόμενα δύο #καταλόγων (τα ονόματα των οποίων θα δέχεται σαν ορίσματα, και θα ελέγχει αν #είναι πράγματι κατάλογοι) ως προς τα αρχεία που περιέχουν. Ως αποτέλεσμα #θα εμφανίζει αρχικά για κάθε κατάλογο ξεχωριστά, πόσα και ποια αρχεία του #δεν περιέχονται στον άλλο κατάλογο και ποιο είναι το συνολικό μέγεθος αυτών. #Στη συνέχεια θα εμφανίζει πόσα και ποια είναι τα κοινά αρχεία των δύο #καταλόγων και το συνολικό μέγεθος αυτών. Τέλος, θα μετακινεί όλα τα κοινά #αρχεία των δύο καταλόγων σε έναν τρίτο κατάλογο (ο οποίος θα #δίνεται/ελέγχεται επίσης σαν όρισμα), και θα δημιουργεί στους δύο αρχικούς #καταλόγους-ορίσματα κατάλληλα hard links προς αυτά.
#Απάντηση: 
#Αρχικά ελέγχω αν το 1ο και 2ο όρισμα είναι κατάλογοι. Μετά #εμφανίζω με την εντολή diff αν υπάρχει κάποιο αρχείο μόνο σε ένα #από τα 2 directories και θα εμφανίσω και ποσά είναι αυτά. Έπειτα θα #ελέγξω αν το ορισμα 3 είναι κατάλογος και αν είναι τότε θα  κοιτάξω #αν  υπάρχει κάποιο αρχείο και στα 2 directories και μετά κρατάω το #2ο και 4ο πεδίο με το Cut ώστε να έχω την μορφή directory/file του #αρχείου. Μετά από αυτό μεταφερω το αρχείο στο 3ο όρισμα και για #να έχω μετά μόνο το όνομα του αρχείου χωρίς το directory που #ανήκει κάνω Cut και μετά παίρνω το όνομα και του κάνω Hard link με #την εντολή ln.




#!/bin/bash
if [ -d "$1" ]; then
    if [ -d "$2" ]; then
        printf "\n"
        echo -n "Only in $1:"
        diff -q $1/ $2/ | grep -c "^Only in $1"
        printf "\n\n"
        diff -q $1/ $2/ | grep "^Only in $1"
        echo -n "Size of $1: $(diff -q $1/ $2/ | grep -c "^Only in $1" | stat | cut -d " " -f 2)"
        printf "\n\n"
        printf "=========================="
        printf "\n\n"
        echo -n "Only in $2:"
        diff -q $1/ $2/ | grep -c "^Only in $2"
        printf "\n\n"
        diff -q $1/ $2/ | grep "^Only in $2"
        echo -n "Size of $2: $(diff -q $1/ $2/ | grep -c "^Only in $2" | stat | cut -d " " -f 2)"
        printf "\n\n"
        printf "=========================="
        printf "\n\n"
        echo -n "Identical files:"
        diff -s $1 $2 | grep -c identical
        diff -s $1 $2 | grep identical
        printf "\n\n"
        if [ -d "$3" ]; then
                arg1=$(diff -s $1 $2 | grep identical | cut -d " " -f 2)
                arg2=$(diff -s $1 $2 | grep identical | cut -d " " -f 4)
                echo
                if [ -z "$arg1" ]; then
                    echo "No identical files found to move"
                else
                    mv $arg1 $3
                    mv $arg2 $3
                    echo "Identical files moved to "$3""
                    echo $($arg1 | cut -d "/" -f 2)
                    filename1=$($arg1 | cut -d "/" -f 2)
                    filename2=$($arg2 | cut -d "/" -f 2)
                    cd $3
#                    ln $filename1 $arg1
#                    ln $filename2 $arg2
                    cd ..
                fi
        else
            echo "The third argument ( "$3" ) is not a directory"
        fi
    else
        echo "The second argument ( "$2" )  is not a directory"
    fi
else 
        echo "The first argument ( "$1" ) is not a directory"
fi