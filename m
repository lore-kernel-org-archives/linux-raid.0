From: Luca Berra <bluca@comedia.it>
Subject: Re: md device on Redhat Linux 3
Date: Wed, 31 Jan 2007 09:06:23 +0100
Message-ID: <20070131080623.GB10802@percy.comedia.it>
References: <207069.41342.qm@web30301.mail.mud.yahoo.com> <17855.59457.265701.451229@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17855.59457.265701.451229@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 31, 2007 at 11:52:17AM +1100, Neil Brown wrote:
>On Tuesday January 30, davidshine@yahoo.com wrote:
>> Hi there,
>> 
>> I am currenlty building a site ysing the following
>> 
>> 2 * IBM DS4300 (SANS)
>> 2 * IBM X346 (intel systems)
>> 2 * HBA on each node
>> 
>> I am using the md device driver to tie the two SANS together and use them in a mirrored environement. So the layout is 3 file systems sitting under and LVM volume group siting under a mirrored SAN (/dev/sdb, /dev/sdc) on 2 g.b. fibre using md driver.
>> 
>> The problem when we write to one of the SANS when he mirror is
>> broken and then take this offline and ring the other SAN online and
>> switch on the RAID array and  varyon the volume group and  finally
>> mount the file system and then dismount the file system,swithc of
>> both the volume group and the RAID array and thn reboot the server
>> it finds the most recently updated disk to be the one written to not
>> the one last mounted. 
>
>It's not really clear to me what you are trying to do here.... maybe
>if you explain your motivations and expectations.
Usually if you get in the unpleasant situation of having two different
versions of your data you _must_ ensure that automatic resyncronization
does not happen at all. (you might need to manually copy data from one
storage to the other)
maybe mdadm could help, by having some options to control startup of
degraded or unclean arrays.
At the moment the best opion is to have a script that checks
availability of device nodes before starting the array, and refuses to
start if the array would be degraded.
In case you need to force a copy to start you can use mdadm --create
with the "missing" option to forcibly kick the other storage from the
array.
Also a nice add-on to mdadm would be a command to increase the event
counter of the remaining devices on a degraded array, to ensure those
will be considered to be uptodate at next restart.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
