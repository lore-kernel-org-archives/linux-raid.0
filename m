From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/3] Don't tell sysfs to launch the container as we are
 doing it ourselves
Date: Tue, 03 Jan 2012 11:24:42 +0100
Message-ID: <4F02D76A.1010002@redhat.com>
References: <1319204000-6661-1-git-send-email-Jes.Sorensen@redhat.com>	<1319204000-6661-3-git-send-email-Jes.Sorensen@redhat.com> <20111223104843.6ef30cba@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111223104843.6ef30cba@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, lukasz.dorau@intel.com, adam.kwolek@intel.com, dledford@redhat.com
List-Id: linux-raid.ids

On 12/23/11 00:48, NeilBrown wrote:
> On Fri, 21 Oct 2011 15:33:19 +0200 Jes.Sorensen@redhat.com wrote:
> 
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> ---
>>  Incremental.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/Incremental.c b/Incremental.c
>> index 1a9a97b..cff7663 100644
>> --- a/Incremental.c
>> +++ b/Incremental.c
>> @@ -446,7 +446,6 @@ int Incremental(char *devname, int verbose, int runstop,
>>  	if (info.array.level == LEVEL_CONTAINER) {
>>  		int devnum = devnum; /* defined and used iff ->external */
>>  		/* Try to assemble within the container */
>> -		sysfs_uevent(&info, "change");
>>  		if (verbose >= 0)
>>  			fprintf(stderr, Name
>>  				": container %s now has %d devices\n",
> 
> Hi Jes,
>  I've had to revert this patch as it causes a regression.
> 
> Without the 'change' event the container device doesn't get created in /dev.
> 
> I'm not sure udev should be running "--incremental" on containers anyway, but
> if it does it shouldn't cause problems should it?  If it does we should fix
> those problems.

Hi Neil,

I am wary of this being reverted as it fixed a genuine race condition.
On Fedora we don't have the problem with the container device not being
created, could it be that your udev scripts are not doing the right
thing in this case?

Cheers,
Jes


Thanks for the heads up!
