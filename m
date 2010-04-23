From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Use of WD20EARS with MDADM
Date: Fri, 23 Apr 2010 12:03:05 +1200
Message-ID: <4BD0E3B9.5090504@sauce.co.nz>
References: <4BAB8D41.4010801@gmail.com>	 <y2x5bdc1c8b1004211036ra8e10a43kc1a13c2b374a5f7b@mail.gmail.com>	 <4BCF4693.3020101@buttersideup.com>	 <201004221913.50692.eye.of.the.8eholder@gmail.com>	 <4BD0A716.4080909@cfl.rr.com> <z2y5bdc1c8b1004221623l3d83165ek3e605d74132a2de3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <z2y5bdc1c8b1004221623l3d83165ek3e605d74132a2de3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, Khelben Blackstaff <eye.of.the.8eholder@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Knecht wrote:

> Keep in mind that just because we possibly solve the load cycle count
> problem doesn't mean that the drive will work for RAID. WD has also
> stated that these drives don't have any TLER features.

I completely agree and wonder if some have unrealistic expectations.

The WD20EARS is listed as a desktop drive and is cheap - $/GB.

The RE-GP, (if you need the green features, otherwise RE series), 
version WD2002FYPS cost more and has the following extra features over 
the WD20EARS:

RAFF - vibration handling
TLER - RAID optimised error handling
An MTBF spec and the comment

"Each drive is put through extended burn-in testing with thermal cycling 
to ensure reliable operation."

Which presumably helps weed out infant mortality cases. It is also 
interesting to note that while all the RE series drives have a spindle 
support bearing at both ends, only the 2TB desktop drive does.

In light of all the above, you get what you pay for and need to adjust 
expectations accordingly.

Regards,

Richard

