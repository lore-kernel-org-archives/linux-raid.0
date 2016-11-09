From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Wed, 9 Nov 2016 13:52:47 -0600
Message-ID: <6f0ddc28-3349-6643-69e4-8f0b4fe770b8@gmail.com>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
 <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
 <c72d3567-7c9c-39dc-c2e1-722bc267bdd6@gmail.com>
 <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
 <c7bfde3e-0605-96d0-4e3d-fb76a9a8c724@gmail.com>
 <27577b8a-1b63-8f1a-9b68-b056622a5268@fnarfbargle.com>
 <41c176d2-0235-6ff0-996c-b32dc95d487d@gmail.com>
 <57EAA214.8030603@youngman.org.uk>
 <5427ce35-f222-8a2c-486e-441c4c6ec9a6@gmail.com>
 <be044941-8097-7d6f-5216-294fe2cac4d9@websitemanagers.com.au>
 <0f6bd6f6-20ee-1720-23fc-27d206063bfc@gmail.com>
 <287df6d6-3850-1142-5c69-c7b54a8a22d4@gmail.com>
 <1497737a-a307-4501-4158-9703a051ef67@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1497737a-a307-4501-4158-9703a051ef67@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/08/2016 02:38 PM, Phil Turmel wrote:
>
> Have you added up the peak current draws of your drives to make sure
> your power supply keeps up when all drives are writing simultaneously
> (common with parity raid)?

Keeping in mind this is a pretty empty box that's pretty sleepy until I hit compile doing FPGA/SoC development.
(i.e. no power hungry graphics cards -- it's a home file server more than a desktop)

Here's them power numbers -- all of the drives are listed as peak (as in start up) where average was much less... but using those hypothetically as worst case:

They still don't touch the supply rails even after considering fans (which spin at very low PWM duty cycles) (not sure this table will print -- let me know if it doesn't)


	
	
	
	
	
	

	*_Model:_* 	*_Wattage_* 	*_+5V_* 	*_+12V_* 	*_+3.3V_* 	*_5V StdBy_*

	PWS-652-2H 	650W 	30A 	54A 	20A 	4A

	
	
	
	
	
	
Slot 1 	WD2500AAJS 	21.24 	
	1.77 	N/A 	N/A
Slot 2 	WD10EZEX 	30 	
	2.5 	N/A 	N/A
Slot 3 	ST1000DM005 	24 	
	2 	N/A 	N/A
Slot 4 	HD103SJ 	36.4 	2 	2.2 	N/A 	N/A
Slot 5 	WD10EFRX-68F 	14.4 	
	1.2 	N/A 	N/A
Slot 6 	HD103SJ 	36.4 	2 	2.2 	N/A 	N/A
Slot 7 	WD10EFRX-68F 	14.4 	
	1.2 	N/A 	N/A
Slot 8 	WD10EFRX-68F 	14.4 	
	1.2 	N/A 	N/A
Slot 9 	Empty 	
	
	
	N/A 	N/A
Slot 10 	Empty 	
	
	
	N/A 	N/A
Slot 11 	WD10JFCX-68N 	5 	1 	0 	N/A 	N/A
Slot 12 	WD10JFCX-68N 	5 	1 	0 	N/A 	N/A

	
	
	
	
	
	

	*Totals:* 	*201.24* 	*6* 	*14.27* 	
	

