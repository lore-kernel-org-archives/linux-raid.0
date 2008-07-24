From: aucoins@comcast.net
Subject: Re: failed device cleanup ?
Date: Thu, 24 Jul 2008 13:41:48 +0000
Message-ID: <072420081341.27209.4888869C0000DBF600006A4922155754749C0207010C9A0E@comcast.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It's only in the summary of the individual array member that there is any 
mention of a "failed" device.

The failed device listed is the one that was previously failed before the array 
was repaired.

In the examine_super1 function of version 2.6.2 of mdadm around line 303 is 
where the word "failed" is being printed in the "Array Slot" status based on the 
"role" derived from the mdp_superblock_1 struct.
    printf("    Array Slot : %d (", __le32_to_cpu(sb->dev_number));
    for (i= __le32_to_cpu(sb->max_dev); i> 0 ; i--)
        if (__le16_to_cpu(sb->dev_roles[i-1]) != 0xffff)
            break;
    for (d=0; d < i; d++) {
        int role = __le16_to_cpu(sb->dev_roles[d]);
        if (d) printf(", ");
        if (role == 0xffff) printf("empty");
        else if(role == 0xfffe) printf("failed");
        else printf("%d", role);
    }

The total number "failed" at the end of the "Array State" line is being printed around line 
331based on the same value.
    for (i=0; i< __le32_to_cpu(sb->max_dev); i++) {
        int role = __le16_to_cpu(sb->dev_roles[i]);
        if (role == 0xFFFE)
            faulty++;
    }
    if (faulty) printf(" %d failed", faulty);

I have a couple concerns around this behavior.

1) The "failed" (role == 0xfffe") entries are being accumulated infinitely. 
Under normal circumstances this would not ordinarily be a problem but in our 
automated test environment it does cause some concern.

2) The report of  "failed" devices in an otherwise healthy array is misleading. 
And, as you can see from the earlier example, the infinite accumulation of 
previously failed devices makes the summary cumbersome.

 -------------- Original message ----------------------
From: aucoins@comcast.net
> I've searched the archives and can't find an answer specific to my question, if 
> the answer is in the archives and someone can rub my nose in it I'd appreciate 
> it.
> 
> What I'm seeing in version 2.6.2 of mdadm is left over "failed" devices in the 
> output from examining an individual device.
> 
> --->Raid Devices : 12
> --->Array Slot : 0 (0, 1, 2, 3, 4, 5, 6, failed, 8, 9, 10, 11, 7)
> --->Array State : Uuuuuuuuuuuu 1 failed
> 
> The array is actually healthy and repaired but the examine option insists on 
> displaying the status for previously failed devices that have been replaced. 
> 
> I took a look at the source and didn't see where the entries for previously 
> failed devices were getting cleaned up once the array was repaired. They appear 
> to accumulate forever or at least until they hit the programmatic "max_dev" 
> limit which appears to be 384 or 512 depending on where you look.
> 
> 6 super1.c getinfo_super1        467 __le32_to_cpu(sb->max_dev) > 512)
> d super1.c add_internal_bitmap1 1218 __le32_to_cpu(sb->max_dev) <= 384)) {
> e super1.c add_internal_bitmap1 1234 if (1 || __le32_to_cpu(sb->max_dev) <= 384) 
> {
> 
> The code looks very similar in older versions (2.3.1) but this behavior escaped 
> our attention because the older version didn't blatantly enumerate "failed" 
> devices in a summary at the bottom of the output.
> 
> --->Raid Devices : 12
> --->Array Slot : 14 (failed, failed, 2, 3, 4, failed, failed, 7, 8, 9, 10, 11, 
> 1, 6, 0, 5)
> --->Array State : Uuuuuuuuuuuu 4 failed
> 
> This might not ordinarily be a concern except that my company is providing a 
> high availability solution which currently employs linux-raid as part of the 
> infrastructure and in the course of testing our product we subject it to an 
> inordinate number of automated hot-plug drive failures and replacements which 
> causes the number of  "failed" devices in the array to grow fairly quickly. It 
> appears the only way to clear the "failed" entries is to delete the array and 
> recreate it, basically a complete reinstall of the product.
> 
> Is there a reason these old superblock entries are not being cleaned up?
> 
> Even if they shouldn't be cleaned up, is there a reason failed devices should 
> appear in the summary once the array is repaired?

