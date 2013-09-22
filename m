From: Phil Turmel <philip@turmel.org>
Subject: Re: raid10 recovery assistance requested
Date: Sun, 22 Sep 2013 17:52:18 -0400
Message-ID: <523F6692.9090407@turmel.org>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com> <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com> <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com> <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Gomboc <dave_gomboc@acm.org>
Cc: linux-raid@vger.kernel.org, stan@hardwarefreak.com
List-Id: linux-raid.ids

On 09/22/2013 01:15 PM, Dave Gomboc wrote:
> Okay,
> 
> I am nervous about losing 10+ years of personal data.  Your help would
> be greatly appreciated!

I reviewed this thread and realized you haven't gotten anywhere.
Unfortunately, reassembly of your array is not likely to be automatic.
Raid10 in default form cannot tolerate adjacent failures, so the fact
that you lack indices 1 & 2 suggest your data is lost.

More, very detailed data will be needed.  Please start with the complete
output of "mdadm -E" for all of the affected partitions, "smartctl -x"
for all of the drives they're on, and if you have it, a copy of the LVM
backup file that describes that part of your system.

Phil
