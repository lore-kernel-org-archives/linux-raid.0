From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Recovering from an URE on a RAID5 rebuild/resize
Date: Fri, 25 Jan 2013 12:34:27 -0600
Message-ID: <5102D033.2070501@hardwarefreak.com>
References: <20130125171459.5f855c92@natsu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130125171459.5f855c92@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/25/2013 5:14 AM, Roman Mamedov wrote:
> Hello,
> 
> Recently there has been some talk on this list, about probability of seeing an
> URE during a RAID5 rebuild on modern large (e.g. 2TB) drives.
> 
> I would like to ask for some advice of what would be the best way to proceed
> when such an URE is encountered. This is mostly theoretical, no real situation
> at hand at the moment.
> 
> As I understand, a RAID5 that is being resized or rebuilt, has no redundancy;
> it is essentially as reliable as a RAID0 of total members-1, or even less.
> 
> So on an unreadable sector that mdadm needs to read (because it has no
> redundancy to recover it from), mdadm will:
> 
>   - mark the corresponding array member as "failed";
>   - mark the one that was being rebuilt/resized onto as "spare";
>   - and the whole array as down and "not enough members to start the array".
> 
> Let's assume only a couple of sectors on that member were unreadable, and then
> their readability was restored (either by drive replacement or by overwriting
> them to making the drive remap), and I would be okay with losing data that was
> in those sectors.
> 
> What would be the best way to proceed from there?

The best way?  Use RAID6 and avoid the situation entirely.

"An ounce of prevention is worth a pound of cure", as they say.

-- 
Stan


