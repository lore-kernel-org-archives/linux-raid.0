From: Hank Barta <hbarta@gmail.com>
Subject: Re: Growing a single disk into a 2 disk raid0
Date: Fri, 28 Jan 2011 19:38:02 -0600
Message-ID: <AANLkTintQJTVy-iv-igOao7cu0VkiYUKoN_GM6qQERCt@mail.gmail.com>
References: <4D42FA3E.6000206@cfl.rr.com>
	<4D4302B6.2090208@panix.com>
	<4D430794.60101@anonymous.org.uk>
	<4D430B01.6040606@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D430B01.6040606@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Berkey B Walker <berk@panix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 28, 2011 at 12:29 PM, Phillip Susi <psusi@cfl.rr.com> wrote:
>
> The idea here was to get more storage and speed by converting to raid-0,
> but without data loss.

RAID0 has no redundancy so all of the media is required for the RAID
to be operable. RAID1 and RAID5 have sufficient redundancy to store
complete information without complete drives.

One implication of that is that if either drive fails, all information
is lost. Since two drives are involved, chance of failure is about
double that of a single drive.

-hank

-- 
'03 BMW F650CS - hers
'98 Dakar K12RS - "BABY K" grew up.
'93 R100R w/ Velorex 700 (MBD starts...)
'95 Miata - "OUR LC"
polish visor: apply squashed bugs, rinse, repeat
Beautiful Sunny Winfield, Illinois
