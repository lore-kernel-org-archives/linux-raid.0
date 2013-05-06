From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH - v2] DM RAID: Add ability to restore transiently failed devices on resume
Date: Mon, 6 May 2013 09:55:50 -0500
Message-ID: <D4677729-5333-4EA4-B587-6D3270AFA108@redhat.com>
References: <1365712023.9799.1.camel@f16> <1367522364.23442.1.camel@f16> <20130506160035.2b84bda5@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130506160035.2b84bda5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, agk@redhat.com
List-Id: linux-raid.ids


On May 6, 2013, at 1:00 AM, NeilBrown wrote:

> On Thu, 02 May 2013 14:19:24 -0500 Jonathan Brassow <jbrassow@redhat.com>
> wrote:
> 
>> DM RAID: Add ability to restore transiently failed devices on resume
>> 
>> This patch adds code to the resume function to check over the devices
>> in the RAID array.  If any are found to be marked as failed and their
>> superblocks can be read, an attempt is made to reintegrate them into
>> the array.  This allows the user to refresh the array with a simple
>> suspend and resume of the array - rather than having to load a
>> completely new table, allocate and initialize all the structures and
>> throw away the old instantiation.
>> 
>> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>> 

<snip/>

>> +1.5.1   Add ability to restore transiently failed devices on resume.
>> 
> 
> 
> Applied thanks.  I assume this is heading for 3.11 ?

3.11 is fine.  thanks,
 brassow

