From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on
 md_attr_store / raid5_make_request
Date: Mon, 22 May 2017 20:07:18 +0100
Message-ID: <592336E6.8080906@youngman.org.uk>
References: <87lgppz221.fsf@esperi.org.uk>
 <87a865jf9a.fsf@notabene.neil.brown.name> <87o9ukykmk.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87o9ukykmk.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/05/17 16:30, Nix wrote:
> I'll give it a try -- I hit it twice in succession, once with a
> --backup-file, once without. Since mdadm does not warn about the lack of
> a --backup-file, I guess the statement in the manual that it is
> essential to provide one when changing RAID levels is untrue: I suspect
> that it's necessary *if* you're not increasing the number of disks at
> the same time, but since I'm growing into a spare, adding a
> --backup-file only slows it down?

I did discuss this with Neil while I wrote it, so I hope I got it right :-)

https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm#Array_internals_and_how_it_affects_mdadm

aiui, provided you're using a v1 superblock, the data offset means there
is spare space on the drives precisely for the purpose (one of then at
least) of keeping a backup. So the reshape will start reshaping into the
spare space and eliminate the need for the backup - the new version of
the stripe will be safely written before the space occupied by the old
stripe is required.

Cheers,
Wol
