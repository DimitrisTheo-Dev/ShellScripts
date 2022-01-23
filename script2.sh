#Εργαστήριο ΛΣ 1 / Ασκηση 2 / 2022 
#Ονοματεπώνυμο: Δημήτριος  Θεοδωρόπουλος

#
# Ερώτηση 2
#Σε μια εφαρμογή χρειάζεται να δημιουργούμε νέους καταλόγους τους οποίους #θα βρίσκει και θα χρησιμοποιεί. Γράψτε ένα script με όνομα createpvs το οποίο #θα καλείται με παραμέτρους ROOTFOLDER, no_of_DBFOLDERS, #no_of_DATAFOLDERS, USERNAME π.χ. createpvs /etc/data 0 5 user555 το #οποίο θα κάνει τα ακόλουθα: • Θα ελέγχει τον αριθμό των ορισμάτων ώστε να #είναι 4 • Θα ελέγχει αν υπάρχει ο ROOTFOLDER μέσα στον οποίο θα #δημιουργηθούν οι νέοι κατάλογοι • Θα ελέγχει αν υπάρχει ο χρήστης #USERNAME (μέσα στο αρχείο /etc/passwd) • Αν όλοι οι έλεγχοι είναι επιτυχείς, - #Θα δημιουργεί τόσους υποφακέλους με όνομα dbfolderΝ μέσα στον #ROOTFOLDER όσους υποδεικνύει το νούμερο no_of_DBFOLDERS και με #τέτοιο τρόπο ώστε να μην κάνει “overwrite” υφιστάμενους φακέλους. Π.χ. αν ο #τελευταίος φάκελος που είχε δημιουργηθεί από προηγούμενη εκτέλεση είναι ο #dbfolder18 και θέλουμε 6 νέους, θα πρέπει να δημιουργήσει τους dbfolder19, #dbfolder20,…,dbfolder24 (αν η παράμετρος είναι 0 δεν θα πρέπει να #δημιουργήσει κανέναν). - To ίδιο θα πρέπει να ισχύει (δηλαδή να #δημιουργούνται χωρίς “overwrite”) και για τους υποφακέλους datafolderN που #καθορίζονται από το no_of_DATAFOLDERS. - Μετά την δημιουργία των #φακέλων, θα χρησιμοποιεί την εντολή chown ώστε να δώσει την κυριότητα των #νέων φακέλων στον χρήστη USERNAME.
#Απάντηση:
#Αρχικά ελέγχω αν τα ορισματα είναι 4. Έπειτα κοιτάω αν το πρώτο είναι κατάλογος. Μετά #κοιτάω αν το 4ο όρισμα που είναι το username υπάρχει χρήσιμοποιωντας την id εντολή. Μετά #κοιτάω αν ο αριθμός που έχω δώσει στο ορισμα νούμερο 2 είναι μεγαλύτερο του 0 έτσι ώστε #να δημιουργήσω τα αρχεία που ζητάει. Κοιτάω με το grep αν υπάρχει το αρχείο αν δεν υπάρχει #το δημιουργώ με τον αριθμό 1 και μετά δημιουργώ όσα αρχεία έχουν δωθεί στο δεύτερο #ορισμα. Επειτα δίνω δικαιώματα με το chown. Μετά κάνω την ίδια διαδικασία απλά η μόνη #διαφορά πέρα από το όνομα του αρχειου είναι ότι κοιτάω σε ποιο directory είμαι έτσι ώστε αν #χρειαστεί να κάνω cd σε αυτό.




#!/bin/bash
if [ $# -eq 4 ]; then
        if [ -d "$1" ]; then
                if id "$4" >/dev/null 2>&1; then
                        if [ $2 -gt 0 ]; then
                                cd $1
                                if !(ls -f | grep "^dbfolder"); then
                                        mkdir "dbfolder1"
                                fi
                                var=$(ls | grep "^dbfolder" | tail -1 | tr -d [a-zA-Z])
                                for ((i = 1 ; i <= $2 ; i++)); do
                                        sum=$(($i + $var))
                                        mkdir "dbfolder${sum}"
                                        chown $4 "dbfolder${sum}"
                                done
                        else
                                echo "Number of files must be more than 0"
                        fi
                        if [ $3 -gt 0 ]; then
                                if pwd | rev | cut -d '/' -f1 | rev -ne $1; then
                    cd $1
                                fi
                                if ! (ls -f | grep "^datafolder"); then
                    mkdir "datafolder1"
                fi
                var=$(ls | grep "^datafolder" | tail -1 | tr -d [a-zA-Z])
                for ((i = 1 ; i <= $3 ; i++)); do
                        sum=$(($i + $var))
                        mkdir "datafolder${sum}"
                        chown $4 "datafolder${sum}"
                done
            else
                echo "Number of files must be more than 0"
            fi


                else
                        echo "username $4 does not exist"
        fi
        else
                echo "Folder $1 does not exist"
        fi
        
else 
        echo "They are not 4. There are $#"
fi