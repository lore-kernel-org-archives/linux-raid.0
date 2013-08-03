From: Sam Bingner <sam@bingner.com>
Subject: Re: MD array keeps resyncing after rebooting
Date: Sat, 3 Aug 2013 00:08:24 +0000
Message-ID: <CE216D89.13F0C%sam@bingner.com>
References: <51FBF830.5060606@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51FBF830.5060606@arcor.de>
Content-Language: en-US
Content-ID: <7673FD7BCBD7314287D2133B234CA0F8@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>, Francis Moreau <francis.moro@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 8/2/13 8:19 AM, "Martin Wilck" <mwilck@arcor.de> wrote:

>On 08/02/2013 02:46 PM, Francis Moreau wrote:
>
>>Please tell me if you can find something suspicous.
>
>The spec says that the VD GUID consists of the vendor ID ("LSI " in
>your case), controller type (the controller's PCI ID,
>8086:1d60:0000:0000), the 4-byte time stamp, and a "random number"
>(0000 1450). Strangely, I also have an LSI fake RAID and it uses the
>same random number. It even generated the same number through several
>RAID creations. Seems to be a truly strange random number generator :-)
>

Perhaps the author reads xkcd and wrote something similar to the following:

int getRandomNumber()
{
	return 0x1450;	// chosen by fair dice roll.
			// guaranteed to be random.
}

http://xkcd.com/221/

Sam

