From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Typical RAID5 transfer speeds
Date: Tue, 22 Dec 2009 07:28:50 +1300
Message-ID: <4B2FBE62.8090702@sauce.co.nz>
References: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com> <4B2D4731.3090702@gmail.com> <4877c76c0912192021s2c3da63au57f5dcb0391b3eb3@mail.gmail.com> <4B2E6CDB.3000707@gmail.com> <4877c76c0912201718l6d7ab948q4c57a07109678cb5@mail.gmail.com> <4B2ED47C.7010307@sauce.co.nz> <4B2F5C5A.7070702@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B2F5C5A.7070702@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Michael Evans <mjevans1983@gmail.com>, Roger Heflin <rogerheflin@gmail.com>, Matt Tehonica <matt.tehonica@mac.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Asdo wrote:
> Richard Scobie wrote:
> 
>> Or use dumb LSI SAS controllers (sas3442e-r with IT firmware loaded, 
>> $200) and port expander based chassis that allow considerable 
>> flexibility regarding md RAID and number of SAS/SATA drives attached.
> 
> 
> The problem then becomes choosing the port expander chassis...
> I know nothing about this topic :-(
> Does the brand/model make difference in performance or reliability?
> Do you have any recommendation? Even just one "known good"...
> (These chassis are also quite expensive for what I can see.)

The only experience I have, is with products from AIC.

I have used 3 of these with WD 750GB RE2 and 1TB RE3 SATA drives:

http://www.aicipc.com/ProductDetail.aspx?ref=RSC-3EC2-2

The port expander is Vitesse based and has a daisy chain output allowing 
connection of another expander.

So far, in over 2 years of use I have not had any trouble with these 
chassis and recently added this chassis (which is essentially the same, 
but without motherboard space):

http://www.aicipc.com/ProductDetail.aspx?ref=XJ1100%20series%20-%203U%2016-bay 


to the external SAS output on one system's controller.

The server chassis cost around $US3300, which I think is quite 
reasonable for a solid, hot swap (disks and fans) enclosure with 
redundent PSU.

Another brand which I have not used but know of others that do, is the 
Dell MD1000.

> Up to 24 and maybe even 48 drives you can find monolithic solutions (one 
> chassis for mainboard and disks), but then not many brands make 16-24 
> ports controllers. LSI does not seem to make them, am I correct?

No, that is the point. These SAS controllers do not have discrete drive 
outputs. The LSISAS3442E HBA I am using can address 122 drives and it is 
the port expanders in the chassis that break out to the drives and allow 
for daisy chaining to more expanders. I'm sure there is a maximum 
recommended number of expanders in a chain, but given the HBA has 2 x 4 
port outputs, a chassis on each chained to another chassis each, covers 
a lot of drives.

> Also in a monolithic storage you only have to check that the controller 
> declares compatibility with the drives (sometimes there are indeed 
> issues) while for port-replicator based storage I don't know if I should 
> check the Compatibility List for drives against controllers, or for 
> drives against port replicator, or for controller against port 
> replicator...?

The AIC site has fairly comprehensive compatibility info for both 
controller and drives. Obviously both need to be considered for 
compatibilty with the expander.

Regards,

Richard

