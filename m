From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Low cost PCI-E unRAID - Supermicro AOC-SASLP-MV8 Driver/LBA questions
 for HW owners/users
Date: Tue, 25 Jan 2011 14:00:09 -0600
Message-ID: <4D3F2BC9.8060904@hardwarefreak.com>
References: <A8.F0.07087.1E7FD3D4@cdptpa-omtalb.mail.rr.com> <4D3F16B0.5070506@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D3F16B0.5070506@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maurice Hilarius put forth on 1/25/2011 12:30 PM:
> On 1/24/2011 3:06 PM, Leslie Rhorer wrote:
>>> ..
>>>>> If you connect 6GB drives and interfaces to it, you see a lot of
>>> errors.

> Of course I was speaking of 6GB/Sec SAS2 drives..

Capital "B" stands for BYTES.  Small "b" stands for bits.
You stated 6 GigaBYTES/sec when you meant to say 6 gigabits/sec.

Always use a BIG B when stating parallel bus data rates.  Always use small b
when stating serial interconnect data rates.  SAS and SATA are serial
interconnect technologies.

You've formed a bad habit which may be difficult to break.  Nonetheless, you
must break this habit if you want those reading your text to correctly
understand what you're saying.

-- 
Stan
