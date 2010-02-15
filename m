From: Dmitry Teytelman <dim@dimtel.com>
Subject: Re: Can this setup be saved?
Date: Mon, 15 Feb 2010 06:02:56 -0800
Message-ID: <c98f60c41002150602n1f9d1534of558045d7b7a563e@mail.gmail.com>
References: <c98f60c41002121756j5e8cd32fwdc2cd22ba553d241@mail.gmail.com>
	 <4877c76c1002121813h410900by1c398c80e2aa0635@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1002121813h410900by1c398c80e2aa0635@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

On Fri, Feb 12, 2010 at 18:13, Michael Evans <mjevans1983@gmail.com> wrote:
> On Fri, Feb 12, 2010 at 5:56 PM, Dmitry Teytelman <dim@dimtel.com> wrote:
>>
>> However at some point during/after the reconstruction the situation
>> has changed. Now both /dev/sdc2 and /dev/sdd2 are marked as spare
>> drives (see mdadm -E output below) and I cannot start the array. I
>> think /dev/sdd2 should be in sync with /dev/sda2, but how can I bring
>> it back (it used to be device 2)?
>
> It sounds like you've reached the point where you've done something
> silly and need to try to recover what you can.
>
> READ THIS SITE CAREFULLY; perform READ ONLY recovery, and see if you
> can find a permutation that can be mounted read only and READ with
> valid data;

I am back on the air!!! Th critical step was the use of "mdadm
--create" with a missing drive. I knew the proper order for the two
drives that were in sync. One of them (/dev/sdd) was failing, so it
was ddrescue-d onto a new drive prior to any repairs. Performing
"mdadm --create" brought the RAID device back to life. I checked that
the data looked OK (read-only). Then I went ahead and added the third
drive to the array. Soon a fully reconstructed device was up and
running. Failed drives are heading back to Hitachi :)

Thanks to the group for rapid response and critically important bits
of information!

-- 
Dmitry Teytelman
