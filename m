From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch v3 2/5] raid5: fix stripe release order
Date: Wed, 28 Aug 2013 14:29:05 +0800
Message-ID: <20130828062905.GA17163@kernel.org>
References: <20130827095038.303090029@kernel.org>
 <20130827095438.580030408@kernel.org>
 <20130828134150.678a5e1e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130828134150.678a5e1e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, tj@kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

On Wed, Aug 28, 2013 at 01:41:50PM +1000, NeilBrown wrote:
> 
> > +struct llist_node *llist_reverse_order(struct llist_node *head)
> > +{
> > +	struct llist_node *second, *third;
> > +
> > +	if (head == NULL || head->next == NULL)
> > +		return head;
> > +	second = head->next;
> > +	head->next = NULL;
> > +
> > +	do {
> > +		third = second->next;
> > +		second->next = head;
> > +
> > +		head = second;
> > +		second = third;
> > +	} while (second);
> > +
> > +	return head;
> > +}
> > +EXPORT_SYMBOL_GPL(llist_reverse_order);
> 
> This is somewhat longer that necessary.
> 
> struct llist_node *llist_reverse_order(struct llist_node *head)
> {
> 	struct llist_node *new_head = NULL;
> 
> 	while (head) {
> 		struct llist_node *tmp = head;
> 		head = head->next;
> 		tmp->next = new_head;
> 		new_head = tmp;
> 	}
> 
> 	return new_head;
> }
> 
> I think that is short enough to just open-code in the top of
> release_stripe_list.
> 
> Are you OK with that?

It's ok. Other patches can still apply with hunks.

Subject: raid5: fix stripe release order

patch "make release_stripe lockless" changes the order stripes are released.
Originally I thought block layer can take care of request merge, but it appears
there are still some requests not merged. It's easy to fix the order.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-08-28 13:51:39.586914255 +0800
+++ linux/drivers/md/raid5.c	2013-08-28 13:53:25.429582150 +0800
@@ -239,6 +239,20 @@ static void __release_stripe(struct r5co
 		do_release_stripe(conf, sh);
 }
 
+static struct llist_node *llist_reverse_order(struct llist_node *head)
+{
+	struct llist_node *new_head = NULL;
+
+	while (head) {
+		struct llist_node *tmp = head;
+		head = head->next;
+		tmp->next = new_head;
+		new_head = tmp;
+	}
+
+	return new_head;
+}
+
 /* should hold conf->device_lock already */
 static int release_stripe_list(struct r5conf *conf)
 {
@@ -247,6 +261,7 @@ static int release_stripe_list(struct r5
 	struct llist_node *head;
 
 	head = llist_del_all(&conf->released_stripes);
+	head = llist_reverse_order(head);
 	while (head) {
 		sh = llist_entry(head, struct stripe_head, release_list);
 		head = llist_next(head);
