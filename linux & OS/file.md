### sed cmd

- sed command enable u to edit files:
some of the sed usefull commands
- sed -i.bak 's/word1/word2/g' file.yaml  #this command replace every word that matches word1 with word2 in the file.yaml and save the original config on file.yaml.ibk
- sed '2s/old/new/g' filename  #This command replaces all occurrences of the string "old" with the string "new" in the second line of the file.

- In the sed command, the % character can be used instead of the forward slash / as a delimiter to specify the pattern to search for. 
The % character is often used as an alternative delimiter when the pattern to search for contains forward slashes.
- usecase scenario:
we use it for exmaple to update the k8s manifest file(update for example the image been used on a deployment) checkout the image below
when we used the sed command to search fotr the image attribute and change it value to what we desire

### Image

Image:
![image](https://user-images.githubusercontent.com/72983573/219065271-d939b6f2-1a42-4153-8a8b-c04ee4256e94.png)
