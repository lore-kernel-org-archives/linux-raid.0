From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH 3/5] add_orom(): Compare content of struct imsm_orom rather
 than pointers to it
Date: Fri, 27 Feb 2015 14:39:42 +0100
Message-ID: <54F0739E.50207@intel.com>
References: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>	<1424811640-26569-4-git-send-email-Jes.Sorensen@redhat.com>	<54EDA91E.5050005@intel.com> <wrfjvbiq2mzo.fsf@redhat.com>	<54EDF91F.40200@intel.com> <wrfj1tld3oa9.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj1tld3oa9.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/25/2015 06:15 PM, Jes Sorensen wrote:
> Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
>> On 02/25/2015 01:29 PM, Jes Sorensen wrote:
>>> Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
>>>> On 02/24/2015 10:00 PM, Jes.Sorensen@redhat.com wrote:
>>>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>>>
>>>>> This avoids adding the same orom entry to the oroms list multiple
>>>>> times, as the comparison of pointers is never going to succeed, in
>>>>> particular when '*orom' points to a local stack variable in the
>>>>> calling function.
>>>>>
>>>>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>>> ---
>>>>>  platform-intel.c | 4 ++--
>>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/platform-intel.c b/platform-intel.c
>>>>> index 37274da..a4ffa9f 100644
>>>>> --- a/platform-intel.c
>>>>> +++ b/platform-intel.c
>>>>> @@ -255,8 +255,8 @@ static const struct imsm_orom *add_orom(const struct imsm_orom *orom)
>>>>>  	int i;
>>>>>  
>>>>>  	for (i = 0; i < SYS_DEV_MAX; i++) {
>>>>> -		if (&oroms[i].orom == orom)
>>>>> -			return orom;
>>>>> +		if (!memcmp(&oroms[i].orom, orom, sizeof(struct imsm_orom)))
>>>>> +			return &oroms[i].orom;
>>>>>  		if (oroms[i].orom.signature[0] == 0) {
>>>>>  			oroms[i].orom = *orom;
>>>>>  			return &oroms[i].orom;
>>>>>
>>>>
>>>> Hi Jes,
>>>>
>>>> You are right that this can add the same entry multiple times, but this
>>>> is how it is supposed to work. The oroms list should contain all the
>>>> platform's oroms and they can be the same, this is why memcmp() should
>>>> not be used here. We don't want to compare the contents of the
>>>> structure, just its address. Sorry if it's not clear.
>>>
>>> Artur,
>>>
>>> Then the code is fundamentally broken, since you end up comparing a
>>> stack variable against the oroms array when you call it from
>>> find_imsm_efi(). Worse you can end up returning the local stack variable
>>> declared in find_imsm_efi() to the calling function - there is no way
>>> that can be correct.
>>>
>>> Look at this:
>>>
>>> static const struct imsm_orom *add_orom(const struct imsm_orom *orom)
>>> {
>>>         int i;
>>>
>>>         for (i = 0; i < SYS_DEV_MAX; i++) {
>>>                 if (&oroms[i].orom == orom)
>>>                         return orom;
>>>                 if (oroms[i].orom.signature[0] == 0) {
>>>                         oroms[i].orom = *orom;
>>>                         return &oroms[i].orom;
>>>                 }
>>>         }
>>>         return NULL;
>>> }
>>>
>>> const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
>>> {
>>>         struct imsm_orom orom;
>>>         const struct imsm_orom *ret;
>>>         int err;
>>>
>>> ....
>>>
>>>         ret = add_orom(&orom);
>>>         add_orom_device_id(ret, hba->dev_id);
>>>
>>>         return ret;
>>> }
>>
>> I can't see how this can lead to returning a stack variable. The oroms
>> array is global and add_orom() will always return a pointer to a struct
>> in this array. This comparison will always fail when we pass a pointer
>> to a stack variable to add_orom():
>>
>> if (&oroms[i].orom == orom)
>> 	return orom;
>>
>> This was meant to prevent adding an orom again like this:
>>
>> ret = add_orom(&orom);
>> add_orom(ret);
>>
>> Maybe it would be more appropriate to return NULL to indicate that
>> nothing was added instead of returning back the same pointer. I can do a
>> patch for this. What do you think?
> 
> It will fail because we know we're comparing a stack pointer, but it
> raises red flags with tools like coverity and it is really bad coding
> practice to rely on hacks like this.
> 
> I also don't understand why you want to keep a table of identical
> entries in the orom structure if multiple identical entries are found.
> Each entry ought to match onto a specific physical controller, unless I
> get something wrong?
> 

OK, you're right, it is a hack. I thought it over and redesigned those
orom functions. This should make it simpler and more consistent.

Thanks,
Artur

From 673ecf1c0539f0050cc5934203af6d79cd68234d Mon Sep 17 00:00:00 2001
From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Date: Fri, 27 Feb 2015 10:34:20 +0100
Subject: [PATCH] imsm: simplified multiple OROMs support

Replaced oroms array with list, add_orom() now only appends to this list
and add_orom_device_id() only appends devid_list node to an orom_entry.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 platform-intel.c | 96 +++++++++++++++++++++++++++-----------------------------
 platform-intel.h |  4 ++-
 super-intel.c    | 18 +++++------
 3 files changed, 57 insertions(+), 61 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 37274da..9c89c20 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -229,65 +229,61 @@ struct pciExpDataStructFormat {
 	__u16 devListOffset;
 } __attribute__ ((packed));
 
-static struct orom_entry oroms[SYS_DEV_MAX];
-
-const struct orom_entry *get_oroms(void)
-{
-	return (const struct orom_entry *)&oroms;
-}
+struct orom_entry *orom_entries;
 
 const struct imsm_orom *get_orom_by_device_id(__u16 dev_id)
 {
-	int i;
-	struct devid_list *list;
+	struct orom_entry *entry;
+	struct devid_list *devid;
 
-	for (i = 0; i < SYS_DEV_MAX; i++) {
-		for (list = oroms[i].devid_list; list; list = list->next) {
-			if (list->devid == dev_id)
-				return &oroms[i].orom;
+	for (entry = orom_entries; entry; entry = entry->next) {
+		for (devid = entry->devid_list; devid; devid = devid->next) {
+			if (devid->devid == dev_id)
+				return &entry->orom;
 		}
 	}
+
 	return NULL;
 }
 
-static const struct imsm_orom *add_orom(const struct imsm_orom *orom)
+static struct orom_entry *add_orom(const struct imsm_orom *orom)
 {
-	int i;
-
-	for (i = 0; i < SYS_DEV_MAX; i++) {
-		if (&oroms[i].orom == orom)
-			return orom;
-		if (oroms[i].orom.signature[0] == 0) {
-			oroms[i].orom = *orom;
-			return &oroms[i].orom;
-		}
-	}
-	return NULL;
+	struct orom_entry *list;
+	struct orom_entry *prev = NULL;
+
+	for (list = orom_entries; list; prev = list, list = list->next)
+		;
+
+	list = xmalloc(sizeof(struct orom_entry));
+	list->orom = *orom;
+	list->devid_list = NULL;
+	list->next = NULL;
+
+	if (prev == NULL)
+		orom_entries = list;
+	else
+		prev->next = list;
+
+	return list;
 }
 
-static void add_orom_device_id(const struct imsm_orom *orom, __u16 dev_id)
+static void add_orom_device_id(struct orom_entry *entry, __u16 dev_id)
 {
-	int i;
 	struct devid_list *list;
 	struct devid_list *prev = NULL;
 
-	for (i = 0; i < SYS_DEV_MAX; i++) {
-		if (&oroms[i].orom == orom) {
-			for (list = oroms[i].devid_list; list; prev = list, list = list->next) {
-				if (list->devid == dev_id)
-					return;
-			}
-			list = xmalloc(sizeof(struct devid_list));
-			list->devid = dev_id;
-			list->next = NULL;
-
-			if (prev == NULL)
-				oroms[i].devid_list = list;
-			else
-				prev->next = list;
+	for (list = entry->devid_list; list; prev = list, list = list->next) {
+		if (list->devid == dev_id)
 			return;
-		}
 	}
+	list = xmalloc(sizeof(struct devid_list));
+	list->devid = dev_id;
+	list->next = NULL;
+
+	if (prev == NULL)
+		entry->devid_list = list;
+	else
+		prev->next = list;
 }
 
 static int scan(const void *start, const void *end, const void *data)
@@ -321,7 +317,7 @@ static int scan(const void *start, const void *end, const void *data)
 	if (!imsm_mem)
 		return 0;
 
-	const struct imsm_orom *orom = add_orom(imsm_mem);
+	struct orom_entry *orom = add_orom(imsm_mem);
 
 	if (ptr->devListOffset) {
 		const __u16 *dev_list = (void *)ptr + ptr->devListOffset;
@@ -367,11 +363,11 @@ const struct imsm_orom *imsm_platform_test(struct sys_dev *hba)
 				IMSM_OROM_RLC_RAID10;
 	}
 
-	const struct imsm_orom *ret = add_orom(&orom);
+	struct orom_entry *ret = add_orom(&orom);
 
 	add_orom_device_id(ret, hba->dev_id);
 
-	return ret;
+	return &ret->orom;
 }
 
 static const struct imsm_orom *find_imsm_hba_orom(struct sys_dev *hba)
@@ -508,7 +504,7 @@ static int read_efi_variable(void *buffer, ssize_t buf_size, char *variable_name
 const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 {
 	struct imsm_orom orom;
-	const struct imsm_orom *ret;
+	struct orom_entry *ret;
 	int err;
 
 	if (check_env("IMSM_TEST_AHCI_EFI") || check_env("IMSM_TEST_SCU_EFI"))
@@ -529,14 +525,14 @@ const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 
 	/* try to read variable for combined AHCI controllers */
 	if (err && hba->type == SYS_DEV_SATA) {
-		static const struct imsm_orom *csata;
+		static struct orom_entry *csata;
 
 		err = read_efi_variable(&orom, sizeof(orom), AHCI_CSATA_PROP, VENDOR_GUID);
 		if (!err) {
 			if (!csata)
 				csata = add_orom(&orom);
 			add_orom_device_id(csata, hba->dev_id);
-			return csata;
+			return &csata->orom;
 		}
 	}
 
@@ -546,12 +542,12 @@ const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 	ret = add_orom(&orom);
 	add_orom_device_id(ret, hba->dev_id);
 
-	return ret;
+	return &ret->orom;
 }
 
 const struct imsm_orom *find_imsm_nvme(struct sys_dev *hba)
 {
-	static const struct imsm_orom *nvme_orom;
+	static struct orom_entry *nvme_orom;
 
 	if (hba->type != SYS_DEV_NVME)
 		return NULL;
@@ -574,7 +570,7 @@ const struct imsm_orom *find_imsm_nvme(struct sys_dev *hba)
 		nvme_orom = add_orom(&nvme_orom_compat);
 	}
 	add_orom_device_id(nvme_orom, hba->dev_id);
-	return nvme_orom;
+	return &nvme_orom->orom;
 }
 
 const struct imsm_orom *find_imsm_capability(struct sys_dev *hba)
diff --git a/platform-intel.h b/platform-intel.h
index 2ead431..631fa76 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -213,8 +213,11 @@ struct devid_list {
 struct orom_entry {
 	struct imsm_orom orom;
 	struct devid_list *devid_list;
+	struct orom_entry *next;
 };
 
+extern struct orom_entry *orom_entries;
+
 static inline char *guid_str(char *buf, struct efi_guid guid)
 {
 	sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
@@ -235,6 +238,5 @@ int devt_attached_to_hba(dev_t dev, const char *hba_path);
 char *devt_to_devpath(dev_t dev);
 int path_attached_to_hba(const char *disk_path, const char *hba_path);
 const char *get_sys_dev_type(enum sys_dev_type);
-const struct orom_entry * get_oroms(void);
 const struct imsm_orom *get_orom_by_device_id(__u16 device_id);
 struct sys_dev *device_by_id(__u16 device_id);
diff --git a/super-intel.c b/super-intel.c
index 819e0da..53269fd 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1948,13 +1948,12 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 		return result;
 	}
 
-	const struct orom_entry *oroms = get_oroms();
-	int i;
+	const struct orom_entry *entry;
 
-	for (i = 0; i < SYS_DEV_MAX && oroms[i].devid_list; i++) {
-		print_imsm_capability(&oroms[i].orom);
+	for (entry = orom_entries; entry; entry = entry->next) {
+		print_imsm_capability(&entry->orom);
 
-		if (imsm_orom_is_nvme(&oroms[i].orom)) {
+		if (imsm_orom_is_nvme(&entry->orom)) {
 			for (hba = list; hba; hba = hba->next) {
 				if (hba->type == SYS_DEV_NVME)
 					printf("    NVMe Device : %s\n", hba->path);
@@ -1963,7 +1962,7 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 		}
 
 		struct devid_list *devid;
-		for (devid = oroms[i].devid_list; devid; devid = devid->next) {
+		for (devid = entry->devid_list; devid; devid = devid->next) {
 			hba = device_by_id(devid->devid);
 			if (!hba)
 				continue;
@@ -2007,11 +2006,10 @@ static int export_detail_platform_imsm(int verbose, char *controller_path)
 			result = 0;
 	}
 
-	const struct orom_entry *oroms = get_oroms();
-	int i;
+	const struct orom_entry *entry;
 
-	for (i = 0; i < SYS_DEV_MAX && oroms[i].devid_list; i++)
-		print_imsm_capability_export(&oroms[i].orom);
+	for (entry = orom_entries; entry; entry = entry->next)
+		print_imsm_capability_export(&entry->orom);
 
 	return result;
 }
-- 
2.1.4

