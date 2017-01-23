From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Re: Input/Output error reading from a clean raid
Date: Mon, 23 Jan 2017 11:42:04 -0300
Message-ID: <CAGmni9qwyHo+G8e4APF99Ai-N_d5WfOhkT0xLoq-8tVkTOjonA@mail.gmail.com>
References: <CAGmni9p7T5VQsSGQrwkpYgV=H4B-pjXtg8TxnuWst-FQSJh_fA@mail.gmail.com>
 <22661.19403.314279.130591@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22661.19403.314279.130591@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The output of the command is:

# dd if=3DFotos.zip of=3D/dev/null
dd: error reading =E2=80=98Fotos.zip=E2=80=99: Input/output error
328704+0 records in
328704+0 records out
168296448 bytes (168 MB) copied, 0.127723 s, 1.3 GB/s

or

# cp Fotos.zip /tmp/
cp: error reading =E2=80=98Fotos.zip=E2=80=99: Input/output error
cp: failed to extend =E2=80=98/tmp/Fotos.zip=E2=80=99: Input/output error


There is nothing on dmesg after running those commands;

[]'s
Salatiel


On Sun, Jan 22, 2017 at 9:18 PM, John Stoffel <john@stoffel.org> wrote:
>
> Salatiel> I am trying to recover a few files from my backup. The
> Salatiel> backup is on a raid 5 + ext4.  There are several files where
> Salatiel> i get I/O error. The raid appears to be clean and fsck shows
> Salatiel> no errors. Any ideas what could it be ?
>
> Salatiel> md1 : active raid5 sdd1[0] sdg1[4] sdf1[2] sde1[1]
> Salatiel>       3220829184 blocks super 1.2 level 5, 512k chunk, algorith=
m 2 [4/4] [UUUU]
> Salatiel>       bitmap: 1/8 pages [4KB], 65536KB chunk
>
> It would help if you could post the error(s) you're getting, along
> with any output from dmesg during that time.  Have you done a full
> scan of the disk looking for errors?  You might just have silent
> read errors in your array.  So as root do:
>
>    # echo check >>/sys/block/md??/md/sync_action
>
> where md?? is the name of your md array you want to check.  You can
> get the name from:
>
>    cat /proc/mdstat
>
> and of course it would help to post that info as well if you want more
> help.
>
> John
