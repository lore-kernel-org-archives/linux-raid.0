From: Luca Berra <bluca@comedia.it>
Subject: Re: Linux mdadm superblock question.
Date: Mon, 15 Feb 2010 08:12:43 +0100
Message-ID: <20100215071243.GA5068@maude.comedia.it>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com> <4B77044B.1020609@zytor.com> <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan> <4B7719C1.1060400@zytor.com> <4B785C49.7010105@shiftmail.org> <4B786898.8030309@zytor.com> <4B788525.6000608@grumpydevil.homelinux.org> <alpine.LNX.2.01.1002141839210.12929@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1002141839210.12929@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 14, 2010 at 06:40:31PM -0900, Mr. James W. Laferriere wrote:
> On Mon, 15 Feb 2010, Rudy Zijlstra wrote:
>> H. Peter Anvin wrote:
>>> IMO it would make sense to support autoassemble for 1.0 superblocks, and
sorry kernel autodetect is borked

>>> making them the default.  The purpose would be to get everyone off 0.9.
>>>  However, *any* default is better than 1.1.

there has been a discussion on what format should be made as the
default, under the subject: "[ANNOUNCE] mdadm-3.1 has been withdrawn",
iirc 1.1 was chosen as the default, versus 1.2, because it puts the
superblock at the very same place as the partition table, thus
preventing any possible confusion between partitioned disk and whole
disk md. (yes someone managed to put both a whole disk 1.2 superblock
and a valid partition table on the same device....)

>> As long is autodetect is supported in the kernel, i am willing to upgrade 
>> to 1.0 superblocks. BUT i need the autodetect in the kernel, as i refuse 
it wont be implemented

>> to use initrd for production servers.
> 	I also have to agree with Rudy in this matter .
>
then use kernel command line

L.

-- 
Luca Berra -- bluca@comedia.it
           Communication Media & Services S.r.l.
    /"\
    \ /     ASCII RIBBON CAMPAIGN
     X        AGAINST HTML MAIL
    / \
