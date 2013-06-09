From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Enlarging device of linear array
Date: Sun, 09 Jun 2013 06:52:09 -0500
Message-ID: <51B46C69.5030205@hardwarefreak.com>
References: <20130608201810.26c19641@hoferr-x61s.hofer.rummelring> <20130609164728.6c21a2f6@natsu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130609164728.6c21a2f6@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Ramon Hofer <ramonhofer@bluewin.ch>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/9/2013 5:47 AM, Roman Mamedov wrote:
> On Sat, 8 Jun 2013 20:18:10 +0200
> Ramon Hofer <ramonhofer@bluewin.ch> wrote:
> 
>> My home server with a linear raid (md0) containing three raid5 (md1,
>> md2, md3) is still working wonderfully. Thanks again Stan!
>>
>> Now I'm planning to add a fourth raid5 to the linear array.
> 
> You should have used LVM instead of md linear to join your RAIDs into a single
> block device. LVM allows placing a single logical volume over physical extents
> placed in all sorts of non-contiguous, fragmented, overlapping fashions. You
> could also transparently migrate portions of those physical extents between
> physical arrays without even having to unmount the filesystem that you have on
> the LV.

FYI, I designed this architecture for Ramon.  He CC's linux-raid as a
courtesy so that others may learn from his experience with it, and in
the event I may be unavailable.

Yes, LVM could have been used.  It was specifically not used because
Ramon is using XFS, which is stripe aligned to each constituent RAID5
array, which each contain a fixed set of allocation groups.  I'm sure
you understand the negative performance implications involved when
breaking alignment with parity RAID, or moving parts of an AG from one
disk or array to another.

-- 
Stan


