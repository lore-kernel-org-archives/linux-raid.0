From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: GPT Table broken on a Raid1
Date: Mon, 24 Sep 2012 10:37:31 +0100
Message-ID: <506029DB.3080407@anonymous.org.uk>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com> <1361158.MkTZ6QR6cp@techz> <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com> <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com> <505DD9E2.7090908@anonymous.org.uk> <F7E53090-1143-4811-86B9-E71923B98AA2@colorremedies.com> <505E368A.4020200@anonymous.org.uk> <6FBE5434-A133-43C0-8296-58978301D32B@colorremedies.com> <505EF9F3.7000908@anonymous.org.uk> <142B3AEB-45FE-4A6E-A03F-BEAA9599C2DC@colorremedies.com> <D14F019C-39C6-4C60-88EF-A7565FA93D6F@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D14F019C-39C6-4C60-88EF-A7565FA93D6F@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23/09/2012 19:53, Chris Murphy wrote:
[...]
> Upon creating a GPT on /dev/md/vol0, identical structures at identical byte offsets are created on /dev/sd[bc] and /dev/md/vol0.
>
> The primary GPT header says the alternate header is at 0xffdfff.
> The alternate GPT header is at 0xffdfff., or sector 16769023, right where it should be.
>
> Regardless of whether the kernel sees the disk as Intel RAID or a bare disk, it finds the alternate GPT header, and doesn't complain about anything.

Yes, it does. It finds the alternate header just fine, according to the 
offset in the primary header, but warns that it's not at the end of the 
disc, which is where it expected to find it:

Sep 17 09:54:27 techz kernel: [    1.204681] GPT:Primary header thinks Alt.
header is not at the end of the disk.
Sep 17 09:54:27 techz kernel: [    1.204685] GPT:625137663 != 625142447
Sep 17 09:54:27 techz kernel: [    1.204687] GPT:Alternate GPT header 
not at
the end of the disk.
Sep 17 09:54:27 techz kernel: [    1.204689] GPT:625137663 != 625142447

I know that's not what I said earlier, so my apologies for that, but it 
remains true that this is not a problem and there are no more GPT 
headers anywhere else on the disc than those written inside the IMSM volume.

Cheers,

John.

