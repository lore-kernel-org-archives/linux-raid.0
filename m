From: Kanoalani Withington <kanoa@cfht.hawaii.edu>
Subject: Re: RAID backup - mtx w/ tcl
Date: Wed, 09 Oct 2002 11:54:51 -1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DA4A5AB.60205@cfht.hawaii.edu>
References: <Pine.LNX.3.96.1021004144923.10481C-100000@Maggie.Linux-Consulting.com> <3D9E148B.7050302@cfht.hawaii.edu> <20021005123036.GB28819@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ah, pardon me.

This may be off subject for this list. I'm only replying here because 
I've lost track of everyone on this thread but I think they were all 
here originally.

Unfortunately I don't have them nicely packaged so they can be used 
generically. I would be willing to do that if there was a need for it 
but I think there are plenty of good GPL archive/backup software 
packages. The only useful thing I think I have is a command line library 
interface which manages, names, tracks, loads and unloads tapes from a 
tape or CD/DVD library using a low level driver like mtx. It has a 
simple text interface and supports device locking and time stamps on 
library operations. It's what I use in all my archive/backup scripts to 
interface with media libraries.

Unfortunately it also uses an SQL database but I could make a standalone 
version if it would be useful to people.

I put what I have on my anonymous ftp server:

  ftp.cfht.hawaii.edu:/pub/daprog/kanoa/libh.tgz

I doubt it is useful to anyone in the state it is in though it might 
have some ideas that are useful and it could adapted to another 
installation.

Aloha,

-Kanoa

Luca Berra wrote:

> On Fri, Oct 04, 2002 at 12:22:03PM -1000, Kanoalani Withington wrote:
>
>> Hi Alvin,
>>
>> Funny, when I searched for it on the web I didn't find anything. The 
>> original was written by Leonard Zubkoff and subsequently modified by 
>> Eric Lee Green. I never got it to work for me until around version 
>> 1.2.15. I emailed Eric to see what's up with it but in the meantime I 
>> put my latest copy of it on my anonymous ftp server:
>>
>> ftp.cfht.hawaii.edu:/pub/daprog/kanoa/mtx-1.2.16rel.tar.gz
>>
> mtx is hosted on sourceforge http://sourceforge.net/projects/mtx
> but i believe Alvin was referring to your tcl scripts
>
> L.
>


