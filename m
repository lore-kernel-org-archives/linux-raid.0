From: Phil Turmel <philip@turmel.org>
Subject: Re: WD Red vs Black drives for RAID1
Date: Mon, 16 Nov 2015 15:02:25 -0500
Message-ID: <564A3651.1010105@turmel.org>
References: <22090.1097.258820.65463@quad.stoffel.home>
 <564A203C.1020309@turmel.org> <22090.13317.824290.574006@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22090.13317.824290.574006@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/16/2015 02:52 PM, John Stoffel wrote:

> So I like the 5 year warranttee on the blacks, but it does look like
> the REDs are the way to go.  And I think I'll also go with splitting
> my data between seagate and WD and possibly Hitachi (I know, they've
> been bought by WD) to make a three way RAID 1 mirror across 4Tb
> drives.  Yes, I'd get more room out of RAID5, but I'm not that silly,
> and I don't need to move to 4 x 4Tb in RAID6 either.

Seagate was the brand that screwed me first with the industry-wide
deletion of ERC support in desktop drives.  Hitachi held onto it the
longest.  Whatever you consider, read the data sheets carefully to
ensure they have ERC support.  Google the model number along with
'linux-raid' and 'scterc' to see our past experiences with specific drives.
