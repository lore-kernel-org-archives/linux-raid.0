From: scar <scar-47zfDnpWZoPQT0dZR+AlfA@public.gmane.org>
Subject: Re: moving spares into group and checking spares
Date: Wed, 14 Sep 2016 10:52:55 -0700
Message-ID: <nrc2pm$2a9$1@blaine.gmane.org>
References: <nramjg$n07$1@blaine.gmane.org>
 <20160914092959.GA3584@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160914092959.GA3584-oubN3LzF/wf25t9ic+4fgA@public.gmane.org>
Sender: linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Andreas Klauer wrote on 09/14/2016 02:29 AM:
> On Tue, Sep 13, 2016 at 10:18:41PM -0700, scar wrote:
>> i currently have four RAID-5 md arrays which i concatenated into one
>> logical volume (lvm2), essentially creating a RAID-50.  each md array
>> was created with one spare disk.
> That's perfect for switching to RAID-6. More redundancy should be
> more useful than spares that only sync in when you already completely
> lost redundancy ...
>
> And the disks would also be covered by your checks that way ;)

i'm not sure what you're suggesting, that 4x 11+1 RAID5 arrays should be 
changed to 1x 46+2 RAID6 array?  that doesn't seem as safe to me.  and 
checkarray isn't going to check the spare disks just as it's not doing 
now.... also that would require me to backup/restore the data so i can 
create a new array


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
