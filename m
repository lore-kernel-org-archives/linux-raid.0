From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: freshly grown array shrinks after first reboot - major data loss
Date: Fri, 02 Sep 2011 11:02:02 +0200
Message-ID: <4E609B8A.9030401@macroscoop.nl>
References: <4E5FA4B5.6010407@macroscoop.nl> <4E5FAEF3.60501@macroscoop.nl> <4E5FAFE9.3040604@macroscoop.nl> <4E5FB762.4050003@yuiop.co.uk> <4E5FBF08.5080709@macroscoop.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5FBF08.5080709@macroscoop.nl>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@yuiop.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/01/2011 07:21 PM, Pim Zandbergen wrote:
> On 1-9-2011 6:48, John Robinson wrote:
>> you should be using partition type DA (Non-FS data)
> using gdisk (GPT) or fdisk (MBR) ?

I tried gdisk but does not know about DA00.

I tried fdisk and created an array from the resulting partitions.
That would only use the first 2TB of the 3TB disks.

Then I tried fdisk, but used the whole disks for the array.
That seems to work, although mdadm gave a lot of warnings
about the fact that the drives were partitioned.
The partition table does not seem to be wiped, however.

Is the latter way the way it is supposed to be done now?

Thanks,
Pim



