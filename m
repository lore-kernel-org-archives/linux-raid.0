From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: Functioning of --backup-file prior to array growth.
Date: Tue, 26 Feb 2013 00:07:56 -0800
Message-ID: <s37uv9x5kb.ln2@goaway.wombat.san-francisco.ca.us>
References: <512C356E.6070803@ejane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2013-02-26, EJ Vincent <ej@ejane.org> wrote:
> I'm preparing to add a disk to an existing RAID6.
>
> In the past (more than one occasion) I've specified: 
> "--backup-file=/disk/not/part/of/array/md.bak" and then, after starting 
> the growth, I've gone to this path, and seen nothing created.
>
> Is this a file that is created *only* in the event of an error / 
> failure? Should some data be written to this .bak file immediately? If 
> not, what could be preventing this file from being created?

From man mdadm (the RAID-DEVICES CHANGES section):

       When relocating the first few stripes on a raid5, it is not possible to
       keep the data on disk completely consistent and crash-proof.   To  pro-
       vide the required safety, mdadm disables writes to the array while this
       "critical section" is reshaped, and takes a backup of the data that  is
       in  that  section.  This backup is normally stored in any spare devices
       that the array has, however it can also be stored in  a  separate  file
       specified  with  the --backup-file option.  If this option is used, and
       the system does crash during the critical period, the same file must be
       passed to --assemble to restore the backup and reassemble the array.


My impression (which may be wrong) is that the backup file is only
needed at the start of the reshape (and probably for raid6 as well as
raid5).  If the backup portion finishes quickly you may never notice the
backup file created.  I'm not sure what would happen if you wanted to
use the backup on a spare instead.

--keith

-- 
kkeller@wombat.san-francisco.ca.us


