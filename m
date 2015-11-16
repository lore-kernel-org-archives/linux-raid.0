From: "John Stoffel" <john@stoffel.org>
Subject: Re: WD Red vs Black drives for RAID1
Date: Mon, 16 Nov 2015 15:16:47 -0500
Message-ID: <22090.14767.83318.49548@quad.stoffel.home>
References: <22090.1097.258820.65463@quad.stoffel.home>
	<564A203C.1020309@turmel.org>
	<22090.13317.824290.574006@quad.stoffel.home>
	<564A3651.1010105@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <564A3651.1010105@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: John Stoffel <john@stoffel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Phil" == Phil Turmel <philip@turmel.org> writes:

Phil> On 11/16/2015 02:52 PM, John Stoffel wrote:
>> So I like the 5 year warranttee on the blacks, but it does look like
>> the REDs are the way to go.  And I think I'll also go with splitting
>> my data between seagate and WD and possibly Hitachi (I know, they've
>> been bought by WD) to make a three way RAID 1 mirror across 4Tb
>> drives.  Yes, I'd get more room out of RAID5, but I'm not that silly,
>> and I don't need to move to 4 x 4Tb in RAID6 either.

Phil> Seagate was the brand that screwed me first with the
Phil> industry-wide deletion of ERC support in desktop drives.
Phil> Hitachi held onto it the longest.  Whatever you consider, read
Phil> the data sheets carefully to ensure they have ERC support.
Phil> Google the model number along with 'linux-raid' and 'scterc' to
Phil> see our past experiences with specific drives.

Yeah, I'm hoping I can find the Hitachis at a good price, but right
now it's looking like the WD REDs are the best price right now.  I'm
just leary of getting too many from the same vendor in case I get a
bad batch.

But it might be ok to get 2 x WD REDs and one of the Seagate NAS
drives to do a triple mirror.  And then wait before I do the pair of
SSDs for lvmcache, though maybe just going with a pair of 64Gb ones
would be enough for my needs.  I really don't change all that many
files a night.

