From: Oliver Heinz <oheinz@fbihome.de>
Subject: Re: Multipath problem [zero Block multipath device creation with
 mdadm 1.8.1]
Date: Thu, 25 Nov 2004 10:43:53 +0100
Message-ID: <41A5A959.2050201@fbihome.de>
References: <41A32AE7.2080502@fbihome.de> <20041123201650.GA8972@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041123201650.GA8972@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra schrieb:

> On Tue, Nov 23, 2004 at 01:19:51PM +0100, Oliver Heinz wrote:
>
>> Mixing mdadm-1.6 and 1.8.1 for creating/managing the device doesn't 
>> work, it gives me an segfault.
>
>
> try patching mdadm-1.8.1 with this patch, it might help with the
> segfault.

This works! Thanks a lot!

Now creating the md-device with versions prior 1.8.1 works (I tested 
1.60 and 1.8.0) - restarting the array with them fails.
With 1.8.1 (with patch applied) I get an 0 Block device created bit I 
can restart the (correct) device I created with 1.60.

Now of course it would be great to get the device created and restarted 
with the same utility. We'd like to use it in production environment 
here, can more experienced mdadm users recommend that, these problems  
did not really strengthen our confidence in mdadm (at least when it 
comes to multipath, we have (of course) been using mdadm successfully 
for raid on severall systems).

Are the code changes in 1.8.1 so drastic that you would recommend to 
stick with prior versions and fix the issue with starting the array or 
would you suggest to get 1.8.1 to get MD creation in 1.8.1 fixed (well 
it need's to be fixed anyway ;-).

Bye,
Oliver


>
>
>------------------------------------------------------------------------
>
>--- mdadm-1.8.1/mdadm.c.bluca	2004-11-14 19:44:26.000000000 +0100
>+++ mdadm-1.8.1/mdadm.c	2004-11-14 19:44:31.747309097 +0100
>@@ -80,11 +80,10 @@
> 
> 	int mdfd = -1;
> 
>-	ident.uuid_set=0;
>+	memset(&ident,0,sizeof(struct mddev_ident_s));
> 	ident.level = UnSet;
> 	ident.raid_disks = UnSet;
> 	ident.super_minor= UnSet;
>-	ident.devices=0;
> 
> 	while ((option_index = -1) ,
> 	       (opt=getopt_long(argc, argv,
>--- mdadm-1.8.1/config.c.bluca	2004-11-02 06:11:06.000000000 +0100
>+++ mdadm-1.8.1/config.c	2004-11-14 19:44:35.693660204 +0100
>@@ -266,15 +266,11 @@
> 	struct mddev_ident_s mis;
> 	mddev_ident_t mi;
> 
>-	mis.uuid_set = 0;
>+	memset(&mis,0,sizeof(struct mddev_ident_s));
> 	mis.super_minor = UnSet;
> 	mis.level = UnSet;
> 	mis.raid_disks = UnSet;
> 	mis.spare_disks = UnSet;
>-	mis.devices = NULL;
>-	mis.devname = NULL;
>-	mis.spare_group = NULL;
>-	mis.autof = 0;
> 
> 	for (w=dl_next(line); w!=line; w=dl_next(w)) {
> 		if (w[0] == '/') {
>  
>
.
