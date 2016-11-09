From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Wed, 9 Nov 2016 13:00:46 -0600
Message-ID: <3c6197d4-a90c-0e7e-995f-6df7d0280e28@gmail.com>
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
 <58223D29.6030401@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58223D29.6030401@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/08/2016 03:01 PM, Wols Lists wrote:
> On 08/11/16 20:38, Phil Turmel wrote:
>> Have you added up the peak current draws of your drives to make sure
>> your power supply keeps up when all drives are writing simultaneously
>> (common with parity raid)?
> On that point, be aware that many power supplies quote the sum of the
> power to all rails. It could well be that the supply is nominally plenty
> powerful enough, but the load on an individual rail is too high.
>
>

Right.. I'll check that when I do the math on the supplies.

  -Ben

