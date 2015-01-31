From: LuVar <luvar@plaintext.sk>
Subject: Re: unsynchronized raid10 with different events count
Date: Sat, 31 Jan 2015 15:33:45 +0100 (GMT+01:00)
Message-ID: <2049102750.36641422714825909.JavaMail.root@shiva>
References: <1468090491.36611422712337250.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1468090491.36611422712337250.JavaMail.root@shiva>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
I have found out something myself. According https://raid.wiki.kernel.org/index.php/RAID_Recovery#Trying_to_assemble_using_--force wiki page, assembling with force can solve my problem. By reading manpage ob mdadm, I have reat this:

<cite>
       -f, --force
              Assemble  the array even if the metadata on some devices appears to be out-of-date.  If mdadm cannot find enough working devices to start the array, but can find some devices that are recorded as having failed, then it will mark those devices as working so that the array can be started.  An array which requires --force to be started may contain data corruption.  Use it carefully.
</cite>

My new answer is, would it use in raid10 (layout n3) disks with same, highest, event count? If yes, I assume, that result will be 100% consistent. Currently, I have these events count:

         Events : 55060
         Events : 55041
         Events : 55060

         Events : 55060
         Events : 55041
         Events : 55041

         Events : 55060
         Events : 55060
         Events : 55041

So for each part of raid0, I have three disks in raid1. In each raid1, there is at least one disk with events = 55060. So if force will use them to restore (sync) content on other raid1 disks, it should be 100% consistent. WHY does not do this mdraid automatically when I request assemble? There is no risk of dataloss from my point ow view, if the biggest event count is contained at least on one part of raid.

Thanks for fast reply,
LuVar

----- "LuVar" <luvar@plaintext.sk> wrote:

> Hi,
> I have raid with 9 devices, layout n3. It is not possible to
> autoassemble it with all devices, because 4 devices has different
> number of events... How can I assemble it fully and sync with 5
> devices which have slightly more events? My current state after mdadm
> --assemble /dev/...... is this: http://pastebin.com/vEpd8WWW
> 
> I know that I can delete those 4 disks and add them again, but I do
> not want to experiment if removed and newly added disk will be on
> correct place in raid and also I would like to not synchronize whole
> disks. They miss only a few events. Is there any possibility?
> 
> PS: here is complete examine output:
> http://cwillu.com:8080/188.121.181.8/8 and cat /proc/mdstat is here:
> http://cwillu.com:8080/188.121.181.8/9
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
