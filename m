From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 02/36] md/bad-block-log: add sysfs interface for
 accessing bad-block-log.
Date: Tue, 26 Jul 2011 12:29:27 +1000
Message-ID: <20110726122927.311602fb@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025847.8422.8246.stgit@notabene.brown>
	<874o2e5nj9.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <874o2e5nj9.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 23 Jul 2011 00:43:22 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> > This can show the log (providing it fits in one page) and
> > allows bad blocks to be 'acknowledged' meaning that they
> > have safely been recorded in metadata.
> >
> > Clearing bad blocks is not allowed via sysfs (except for
> > code testing).  A bad block can only be cleared when
> > a write to the block succeeds.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >
> >  drivers/md/md.c |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 127 insertions(+), 0 deletions(-)
> >

> > +static ssize_t
> > +badblocks_store(struct badblocks *bb, const char *page, size_t len, int unack)
> > +{
> > +	unsigned long long sector;
> > +	int length;
> > +	char newline;
> > +#ifdef DO_DEBUG
> > +	/* Allow clearing via sysfs *only* for testing/debugging.
> > +	 * Normally only a successful write may clear a badblock
> > +	 */
> > +	int clear = 0;
> > +	if (page[0] == '-') {
> > +		clear = 1;
> > +		page++;
> > +	}
> > +#endif /* DO_DEBUG */
> > +
> > +	switch (sscanf(page, "%llu %d%c", &sector, &length, &newline)) {
> 
> What if user provides negative 'length' here? Should we check that case?
> 

good point.  I've added an appropriate test.

Thanks,
NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5de0c84..9ba76c7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7844,6 +7844,8 @@ badblocks_store(struct badblocks *bb, const char *page, size_t len, int unack)
 		if (newline != '\n')
 			return -EINVAL;
 	case 2:
+		if (length <= 0)
+			return -EINVAL;
 		break;
 	default:
 		return -EINVAL;
