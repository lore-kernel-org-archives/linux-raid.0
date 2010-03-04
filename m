From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Re: RAID MIA. Again. (Kinda.)
Date: Thu, 4 Mar 2010 18:41:34 -0500 (EST)
Message-ID: <e787a69f754f9d4348ebf2d608434f6b.squirrel@webmail.jots.org>
References: <ef2f0a4210283390480f4adbd9a547de.squirrel@webmail.jots.org>
    <20100305075016.51e98363@notabene.brown>
    <b305ada429c44b2b62b03c101f7ecf0a.squirrel@webmail.jots.org>
    <4877c76c1003041421s42717938he6567434b74ec125@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003041421s42717938he6567434b74ec125@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Ken D'Ambrosio <ken@jots.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, March 4, 2010 5:21 pm, Michael Evans wrote:
> Try providing the output of;
> for ii in /dev/[sh]d[a-z] ; do parted $ii print ; done

Mea culpa; I'd said:

 I went through all 24 permutations of
 mdadm --assemble /dev/md0 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2
 since I wasn't sure if the drive order was significant.  All of them
 "worked," inasmuch as they created /dev/md0, but in all cases it was
 partitionless.

Which I assumed implied that /dev/sd[a-d]2 was valid on all disks, though,
in hindsight, I wasn't explicit.  So: /dev/sd[a-d]2 exists on all drives
as partition id "fd" (Linux raid autodetect).  It's /dev/md0 that shows as
a valid, 4.4 TB disk... with no partition.

-Ken


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

