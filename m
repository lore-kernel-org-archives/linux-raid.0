From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] MD:  Do not increment resync_mismatches unless MD_RECOVERY_REQUESTED
Date: Mon, 22 Apr 2013 13:22:11 -0400
Message-ID: <517571C3.3060302@redhat.com>
References: <1366402161.18514.1.camel@f16> <20130422103626.4cdcefae@notabene.brown> <2BD5F32D-4C11-4DA6-A38B-DFA030D78489@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2BD5F32D-4C11-4DA6-A38B-DFA030D78489@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/22/2013 12:26 PM, Brassow Jonathan wrote:
> 
> On Apr 21, 2013, at 7:36 PM, NeilBrown wrote:
> 
>> On Fri, 19 Apr 2013 15:09:21 -0500 Jonathan Brassow
>> <jbrassow@redhat.com> wrote:
>> 
>>> MD:  Do not increment resync_mismatches unless
>>> MD_RECOVERY_REQUESTED
>>> 
>>> resync_mismatches is used to display the number of differences
>>> that have been found or repaired during a scrubbing operation.
>>> It is not meant to count anything during resync or repair
>>> operations.  (How much sense does it make to find
>>> resync_mismatches populated after an initial synchronization of
>>> the array?  After cleaning-up an unclean shutdown?  After
>>> [re]integrating a device into an existing array?) The
>>> incrementing of the variable must be restricted to when the user 
>>> initiates a scrubbing operation (i.e. "check" or "repair").
>> 
>> How do you know what it is "meant" to do? :-)
> 
> Yes, I suppose I did infer the meaning, but I don't think it's too
> much of a stretch - especially given the commit message where
> 'resync_mismatches' was introduced.

Which also matches the understanding other people have had for a long
time ;-)

The information Neil doesn't want to throw away is a valid issue, but
maybe the proper thing to do here is to have two counters:
repaired_mistmatches and detected_mismatches, and then you can infer
total_mismatches from that, and add mismatch_cnt_since (which makes more
sense to me than last_sync_action if you're using it to delimit when you
started the current mismatch counts) as a representation of when you
started the current counts.  If it was since boot, or since disk add, or
since check/repair, whatever, you put that in the since file (which I
think answers your other question you had about a set of flags or
text...I personally think text since the last operation that we might
want to record could be assemble or something like that).  That way you
aren't throwing anything away, but you also aren't confusing people and
making them concerned since most people think mismatch_cnt is
uncorrected errors found, having that increment for corrected issues
found during assembly or something can certainly confuse people.


