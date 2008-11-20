From: Drew <drew.kay@gmail.com>
Subject: Re: Backups using RAID1
Date: Wed, 19 Nov 2008 18:11:43 -0800
Message-ID: <c268e4660811191811y2b3d11d9na6bd3a64b636d217@mail.gmail.com>
References: <c268e4660811170713y64b2a707p2d0fcfbca0b0d1c6@mail.gmail.com>
	 <62c47030811191213n49a50624k4a0e167f20193a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62c47030811191213n49a50624k4a0e167f20193a4@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 19, 2008 at 12:13 PM, Linux <linuxlist@gmail.com> wrote:
>> In recent months I've been exploring low cost solutions for backing up
>> the data on my home media server. I already run three raid-1 arrays on
>> this rig to protect against drive failures and a fellow linux user
>> suggested I consider using the existing raid, just yank the 'backup'
>> disks as needed, and drop in fresh disks to replace the yanked unit.
>
> I guess this is a little risky. Plugging disks too often does not  sound good.
> Is "rsync" not enough for you?

A year ago my old 10GB Travan & 4 tapes was enough to backup my OS and
data. In the last year I've seen my data storage jump from 40GB to 2TB
courtesy of a MythTV installation. I'm still figuring out how to
manage this large an amount of data and backup solutions are now on
the table as it's been indicated to me that loss of important 'media'
will result in a greatly lowered WAF(*).


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

(*) WAF: Wife Acceptance Factor
