From: Marcin Wanat <mwanat@forall.pl>
Subject: Re: Raid10 to Raid0 conversion
Date: Mon, 31 Mar 2014 14:18:43 +0200
Message-ID: <53395D23.4080601@forall.pl>
References: <532D6F06.1010901@forall.pl> <20140331173807.7f539ea9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140331173807.7f539ea9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2014-03-31 08:38, NeilBrown wrote:
> I don't think it is you. What does /sys/block/md1/md/degraded contain? 
> If it isn't '2', then that is the problem. Maybe if you stop the array 
> the array and assemble it again it could get that right.

In fact i have resolved this issue a day later.
I saw that despite output of mdadm --detail (which was WD=RD=4), in 
dmesg there was: RD: 5, WD:4 so i guessed that raid array was not 
degraded correctly.
I have fixed it by just stopping and reassembling the array as you said.

Regards,
Marcin Wanat
