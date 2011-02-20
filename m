From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Sun, 20 Feb 2011 13:48:56 -0500
Message-ID: <4D616218.1060905@turmel.org>
References: <4D540F6C.6050904@gmail.com>	<20110215155315.55d35b8e@notabene.brown>	<4D5A92F3.1090004@turmel.org>	<4D5BD678.2050200@gmail.com>	<4D5BE119.7000804@turmel.org>	<4D5C0E17.3060306@gmail.com>	<4D5C140F.9010301@turmel.org>	<4D5C1508.3040308@gmail.com>	<4D5C15D3.1070608@turmel.org>	<4D5C167C.7000101@turmel.org>	<4D5C1CF8.1020507@gmail.com>	<4D5C1E0B.9060300@turmel.org>	<4D5C2061.4060106@gmail.com>	<4D5C2143.3000907@turmel.org>	<4D5C2260.3020800@gmail.com>	<4D5C273E.7020609@turmel.org> <AANLkTi=RmR5nVnmFLuqK5anHc3WDPxjuYjitT6+5wAqS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=RmR5nVnmFLuqK5anHc3WDPxjuYjitT6+5wAqS@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Mcnair <simonmcnair@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/20/2011 12:03 PM, Simon Mcnair wrote:
> Hi Phil,
> 
> Is this fsck (fsck.ext4 -n -b 32768 /dev/mapper/lvm--raid-RAID
>> fsck.txt) as bad as it looks ? :-(

It's bad.  Either the original sdd has a lot more corruption than I expected, or the 3ware spread corruption over all the drives.

If the former, failing it out of the array might help.  If the latter, your data is likely toast.  Some identifiable data is being found, based on the used vs. free block/inode/directory counts in that report.  That's good.

I suggest you do "mdadm /dev/md0 --fail /dev/sdi1" and repeat the "fsck -n" as above.

(It'll be noticably slower, as it'll be using parity to reconstruct 1 out every 9 chunks.)

If it the fsck results improve, or stay the same, proceed to "fsck -y", and we'll see.

Wouldn't hurt to run "iostat -xm 5" in another terminal during the fsck to see what kind of performance that array is getting.

Phil
