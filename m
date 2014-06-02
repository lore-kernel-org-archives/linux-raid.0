From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] imsm: retry load_and_parse_mpb if we suspect mdmon has
 made modifications
Date: Mon, 02 Jun 2014 15:02:59 +0200
Message-ID: <538C7603.3050204@intel.com>
References: <1401455913-28657-1-git-send-email-artur.paszkiewicz@intel.com> <20140602123656.2e52d529@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140602123656.2e52d529@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

On 06/02/2014 04:36 AM, NeilBrown wrote:
> On Fri, 30 May 2014 15:18:33 +0200 Artur Paszkiewicz
> <artur.paszkiewicz@intel.com> wrote:
> 
>> If the checksum verification fails in mdadm and mdmon is running, retry
>> the load to get a consistent snapshot of the mpb.
>>
>> Based on db575f3b
>>
>> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>> Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
>> ---
>>  super-intel.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/super-intel.c b/super-intel.c
>> index f0a7ab5..037c018 100644
>> --- a/super-intel.c
>> +++ b/super-intel.c
>> @@ -4422,6 +4422,7 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
>>  {
>>  	struct intel_super *super;
>>  	int rv;
>> +	int retry;
>>  
>>  	if (test_partition(fd))
>>  		/* IMSM not allowed on partitions */
>> @@ -4444,6 +4445,22 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
>>  	}
>>  	rv = load_and_parse_mpb(fd, super, devname, 0);
>>  
>> +	/* retry the load if we might have raced against mdmon */
>> +	if (rv == 3) {
>> +		struct mdstat_ent *mdstat = mdstat_by_component(fd2devnm(fd));
>> +
>> +		if (mdmon_running(mdstat->devnm) && getpid() != mdmon_pid(mdstat->devnm)) {
>> +			for (retry = 0; retry < 3; retry++) {
>> +				usleep(3000);
>> +				rv = load_and_parse_mpb(fd, super, devname, 0);
>> +				if (rv != 3)
>> +					break;
>> +			}
>> +		}
> 
> The only thing you use from mdstat is devnm, and that is the thing you passed
> to mdstat_by_component to get mdstat....
> 
> Can you just do
>    char *devnm = fd2devnm(fd);
>    if (mdmon_running(devnm) && ......)
> 
> ??
> 
I can't do that because mdmon_running and mdmon_pid need a devnm of a
container device, and the only thing we have here is the file descriptor
of a component device. So I used mdstat_by_component to get the
container devnm. Do you have an idea how to get that reliably without
reading mdstat?

I have overlooked that mdstat_by_component can return NULL here. I've
added a check for this in the patch below.

Thanks,
Artur

From dfb12870a482654b405ec1d4d9d3a8ba69a6290c Mon Sep 17 00:00:00 2001
From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Date: Tue, 27 May 2014 15:30:54 +0200
Subject: [PATCH] imsm: retry load_and_parse_mpb if we suspect mdmon has made
 modifications

If the checksum verification fails in mdadm and mdmon is running, retry
the load to get a consistent snapshot of the mpb.

Based on db575f3b

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index f0a7ab5..9dd807a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4422,6 +4422,7 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 {
 	struct intel_super *super;
 	int rv;
+	int retry;
 
 	if (test_partition(fd))
 		/* IMSM not allowed on partitions */
@@ -4444,6 +4445,22 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 	}
 	rv = load_and_parse_mpb(fd, super, devname, 0);
 
+	/* retry the load if we might have raced against mdmon */
+	if (rv == 3) {
+		struct mdstat_ent *mdstat = mdstat_by_component(fd2devnm(fd));
+
+		if (mdstat && mdmon_running(mdstat->devnm) && getpid() != mdmon_pid(mdstat->devnm)) {
+			for (retry = 0; retry < 3; retry++) {
+				usleep(3000);
+				rv = load_and_parse_mpb(fd, super, devname, 0);
+				if (rv != 3)
+					break;
+			}
+		}
+
+		free_mdstat(mdstat);
+	}
+
 	if (rv) {
 		if (devname)
 			pr_err("Failed to load all information "

