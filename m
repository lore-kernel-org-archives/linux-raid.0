From: Neil Brown <neilb@suse.de>
Subject: Re: Time to  deprecate old RAID formats?
Date: Tue, 30 Oct 2007 14:10:28 +1100
Message-ID: <18214.41124.114701.370212@notabene.brown>
References: <20071020075349.GA17431@teal.hq.k1024.org>
	<1192885917.1666.112.camel@firewall.xsintricity.com>
	<20071026095417.GC32550@percy.comedia.it>
	<1193424779.10336.287.camel@firewall.xsintricity.com>
	<20071026223046.GB8210@boogie.lpds.sztaki.hu>
	<1193531160.10336.397.camel@firewall.xsintricity.com>
	<20071028141336.GC22861@percy.comedia.it>
	<1193593675.10336.404.camel@firewall.xsintricity.com>
	<20071029084118.GC15475@percy.comedia.it>
	<1193671853.10336.428.camel@firewall.xsintricity.com>
	<20071029214416.GB24635@percy.comedia.it>
	<1193699142.10336.503.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Monday October 29
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 29, dledford@redhat.com wrote:
> 
> The one thing I *do* like about mdadm -E above -D is it includes the
> superblock format in its output.  The one thing I don't like, is it
> almost universally gets the name wrong.  What I really want is a brief
> query format that both gives me the right name (-D) and the superblock
> format (-E).
> 


You need only ask:-)

Following patch will be in next release.  Thanks for the suggestion.

NeilBrown


### Diffstat output
 ./Detail.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff .prev/Detail.c ./Detail.c
--- .prev/Detail.c	2007-10-30 14:04:25.000000000 +1100
+++ ./Detail.c	2007-10-30 14:08:28.000000000 +1100
@@ -143,7 +143,10 @@ int Detail(char *dev, int brief, int exp
 	}
 
 	if (brief)
-		printf("ARRAY %s level=%s num-devices=%d", dev, c?c:"-unknown-",array.raid_disks );
+		printf("ARRAY %s level=%s metadata=%d.%d num-devices=%d", dev,
+		       c?c:"-unknown-",
+		       array.major_version, array.minor_version,
+		       array.raid_disks );
 	else {
 		mdu_bitmap_file_t bmf;
 		unsigned long long larray_size;

