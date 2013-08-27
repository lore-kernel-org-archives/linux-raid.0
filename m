From: Shaohua Li <shli@kernel.org>
Subject: [patch v3 2/5] raid5: fix stripe release order
Date: Tue, 27 Aug 2013 17:50:40 +0800
Message-ID: <20130827095438.580030408@kernel.org>
References: <20130827095038.303090029@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-release_stripe-order.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, tj@kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

patch "make release_stripe lockless" changes the order stripes are released.
Originally I thought block layer can take care of request merge, but it appears
there are still some requests not merged. It's easy to fix the order.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c    |    1 +
 include/linux/llist.h |    1 +
 lib/llist.c           |   27 +++++++++++++++++++++++++++
 3 files changed, 29 insertions(+)

Index: linux/include/linux/llist.h
===================================================================
--- linux.orig/include/linux/llist.h	2013-07-24 09:09:41.014384439 +0800
+++ linux/include/linux/llist.h	2013-07-25 15:09:03.109026773 +0800
@@ -172,4 +172,5 @@ static inline struct llist_node *llist_d
 
 extern struct llist_node *llist_del_first(struct llist_head *head);
 
+extern struct llist_node *llist_reverse_order(struct llist_node *head);
 #endif /* LLIST_H */
Index: linux/lib/llist.c
===================================================================
--- linux.orig/lib/llist.c	2013-07-24 09:09:41.062383834 +0800
+++ linux/lib/llist.c	2013-07-25 16:08:40.096054565 +0800
@@ -81,3 +81,30 @@ struct llist_node *llist_del_first(struc
 	return entry;
 }
 EXPORT_SYMBOL_GPL(llist_del_first);
+
+/*
+ * llist_reverse_order - reverse llist order
+ * @head: list head
+ *
+ * Return reversed list head
+ */
+struct llist_node *llist_reverse_order(struct llist_node *head)
+{
+	struct llist_node *second, *third;
+
+	if (head == NULL || head->next == NULL)
+		return head;
+	second = head->next;
+	head->next = NULL;
+
+	do {
+		third = second->next;
+		second->next = head;
+
+		head = second;
+		second = third;
+	} while (second);
+
+	return head;
+}
+EXPORT_SYMBOL_GPL(llist_reverse_order);
Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-07-25 15:02:38.289865404 +0800
+++ linux/drivers/md/raid5.c	2013-07-25 15:35:33.201040089 +0800
@@ -247,6 +247,7 @@ static int release_stripe_list(struct r5
 	struct llist_node *head;
 
 	head = llist_del_all(&conf->released_stripes);
+	head = llist_reverse_order(head);
 	while (head) {
 		sh = llist_entry(head, struct stripe_head, release_list);
 		head = llist_next(head);

