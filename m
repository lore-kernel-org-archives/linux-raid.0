From: Mike Hardy <mhardy@h3c.com>
Subject: Re: No response?
Date: Thu, 20 Jan 2005 10:21:31 -0800
Message-ID: <41EFF6AB.8030204@h3c.com>
References: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This hasn't been my experience, and I just had a drive journey across 
the river styx a few days back. It was in a RAID1 mirror, and while I 
got some log messages about it, and smartd and mdadm both sent me email, 
the software raid device and the machine in general both kept ticking along.

That was 2.6.10 and ext3, but I've also had this experience in the 2.4 
series, with ext3.

Either its an xfs interaction, there's something else going on.

There was mention recently of RAID1 corruption, but I believe that was 
in reference to 2.6.10, and there have only been two reports, where I'd 
expect a storm of reports if it was ocurring to more people.

Regardless, perhaps its possible to test it yourself by assembling a 
couple of disk files into loopback bindings with LVM's faulty block 
support on them, and finally a raid mirror on top. Sounds a bit like a 
house of cards, but you'd be able to simulate a failing drive that way 
with xfs on it, and see how the mirror and filesystem react

-Mike

David Dougall wrote:
> Perhaps I was asking a stupid question or an obvious one, but I have
> received not response.
> Maybe if I simplify the question...
> 
> If I am running software raid1 and a disk device starts throwing I/O
> errors, Is the filesystem supposed to see any indication of this?  I
> thought software raid would mask all of this and just fail the drive.
> 
> I have servers with xfs as the filesystem and xfs will start to throw I/O
> errors when a disk starts acting up even with software raid in between.
> Please advise on how I can confirm my setup or if this is possibly a bug
> how to diagnose further.
> If it makes a difference, I am running linux-2.4.26
> Thanks
> --David Dougall
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
