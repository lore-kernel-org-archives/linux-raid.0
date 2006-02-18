From: Antonello PAPA <anto.papa@inwind.it>
Subject: Re: quota on raid
Date: Sat, 18 Feb 2006 14:30:47 +0100
Message-ID: <6.0.0.22.0.20060218142902.02efd340@popmail.inwind.it>
References: <6.0.0.22.0.20060218020849.02a207a0@popmail.inwind.it>
 <20060218084203.GA947@percy.comedia.it>
 <20060218084910.GB947@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060218084910.GB947@percy.comedia.it>
References: <6.0.0.22.0.20060218020849.02a207a0@popmail.inwind.it>
 <20060218084203.GA947@percy.comedia.it>
 <20060218084910.GB947@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 09.49 18/02/06, you wrote:
>On Sat, Feb 18, 2006 at 09:42:04AM +0100, Luca Berra wrote:
>>On Sat, Feb 18, 2006 at 02:12:26AM +0100, Antonello PAPA wrote:
>>>i have two disk with raid 1. i can't find documents on how to set the 
>>>quotas.
>>>i whould like to set the quota on /home, can some opne help? thanks and 
>>>sorry for bad english.
>>>antonello
>>
>>in italian:
>>http://www.lnf.infn.it/computing/doc/AppuntiLinux/a296.html
>sorry,
>this is the _current_ version
>http://a2.swlibero.org/a2111.htm
i have used that document but it doesn't work. This is my fstab:

/dev/md1     /               ext3    defaults        1 1
/dev/md0     /boot        ext3    defaults        1 2
/dev/devpts  /dev/pts   devpts  gid=5,mode=620  0 0
/dev/shm      /dev/shm  tmpfs   defaults        0 0
/dev/md5   /home   ext3, usrquota, grpquota defaults    1 2

thanks 


