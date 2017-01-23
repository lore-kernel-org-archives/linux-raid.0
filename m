From: "John Stoffel" <john@stoffel.org>
Subject: Re: Input/Output error reading from a clean raid
Date: Mon, 23 Jan 2017 11:12:09 -0500
Message-ID: <22662.11097.686660.213864@quad.stoffel.home>
References: <CAGmni9p7T5VQsSGQrwkpYgV=H4B-pjXtg8TxnuWst-FQSJh_fA@mail.gmail.com>
        <22661.19403.314279.130591@quad.stoffel.home>
        <CAGmni9qwyHo+G8e4APF99Ai-N_d5WfOhkT0xLoq-8tVkTOjonA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGmni9qwyHo+G8e4APF99Ai-N_d5WfOhkT0xLoq-8tVkTOjonA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Salatiel Filho <salatiel.filho@gmail.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Salatiel> The output of the command is:
Salatiel> # dd if=Fotos.zip of=/dev/null
Salatiel> dd: error reading ‘Fotos.zip’: Input/output error
Salatiel> 328704+0 records in
Salatiel> 328704+0 records out
Salatiel> 168296448 bytes (168 MB) copied, 0.127723 s, 1.3 GB/s

Salatiel> or

Salatiel> # cp Fotos.zip /tmp/
Salatiel> cp: error reading ‘Fotos.zip’: Input/output error
Salatiel> cp: failed to extend ‘/tmp/Fotos.zip’: Input/output error

Can you do a 'zip -l Fotos.zip' and get anything back?  It looks like
the first 168mb might be ok... so you might get something back.

You might also want to try and start doing a dd from 328705 records
(or even a couple more records farther) to see if you can get anything
else from there.

In this case, the tool 'ddrescue' might be your answer, since it is
designed to handle errors like this and continue reading past errors.
It might, or might not, let you get more of your data back.  On debian based
systems you should be able to just do:

	apt-get install gddrescue

or just do:

   apt-cache search ddrescue

For RedHat fedora you could do:

   dnf search ddrescue

too.  

Did you run the "echo check > ..." command at all?  What did it say in
the output of: cat /proc/mdstat  when you did this?  

Salatiel> There is nothing on dmesg after running those commands;

You might be out of luck.  This is one reason why I like A) mirroring
my data and B) saving multiple copies to multiple locations.  Storage
is cheap these days.

Though I admit I'm not perfect either.

Please get us more information so we can try to help more.

Also, have you unmounted the filesystem and done an 'fsck -y /dev/...'
on it as well?  You might want to do a more in-depth check of the
filesystem to see if there's any corruption somewhere.

Also, going to the end of the file, and seeking backwards and reading
off blocks might help you recover more of the zip file.



Salatiel> On Sun, Jan 22, 2017 at 9:18 PM, John Stoffel <john@stoffel.org> wrote:
>> 
Salatiel> I am trying to recover a few files from my backup. The
Salatiel> backup is on a raid 5 + ext4.  There are several files where
Salatiel> i get I/O error. The raid appears to be clean and fsck shows
Salatiel> no errors. Any ideas what could it be ?
>> 
Salatiel> md1 : active raid5 sdd1[0] sdg1[4] sdf1[2] sde1[1]
Salatiel> 3220829184 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
Salatiel> bitmap: 1/8 pages [4KB], 65536KB chunk
>> 
>> It would help if you could post the error(s) you're getting, along
>> with any output from dmesg during that time.  Have you done a full
>> scan of the disk looking for errors?  You might just have silent
>> read errors in your array.  So as root do:
>> 
>> # echo check >>/sys/block/md??/md/sync_action
>> 
>> where md?? is the name of your md array you want to check.  You can
>> get the name from:
>> 
>> cat /proc/mdstat
>> 
>> and of course it would help to post that info as well if you want more
>> help.
>> 
>> John
