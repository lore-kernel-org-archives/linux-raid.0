From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Observations of a failing disk
Date: Tue, 28 Nov 2006 13:52:12 +1300
Message-ID: <456B883C.4050304@sauce.co.nz>
References: <456B65E1.20204@sauce.co.nz> <Pine.LNX.4.64.0611271623270.8068@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0611271623270.8068@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

dean gaudet wrote:

> one theory was that i lucked out and the pending sectors in the unused 
> disk near the md superblock... but since that's in general only about 90KB 
> of disk i was kind of skeptical.  it's certainly possible, but seems 
> unlikely.

I can discount this one in my case, as sectors were being repaired 
progressively across the disk, as can be seen in the smartd reports.

You can't have too many checks is the moral of the story I guess.

Regards,

Richard
