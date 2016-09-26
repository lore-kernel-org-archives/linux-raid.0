From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux raid wiki
Date: Mon, 26 Sep 2016 10:01:28 -0400
Message-ID: <c6d53f0f-4434-9703-cfab-b148dd8dd68b@turmel.org>
References: <57E469E0.4020005@youngman.org.uk>
 <57E67D32.30108@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57E67D32.30108@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Wol,

A few comments below.

On 09/24/2016 09:18 AM, Wols Lists wrote:
> On 23/09/16 00:31, Wols Lists wrote:
>> I've added the "When Things Go Wrogn" section, but so far only the first
>> two pages - "Asking for help" and "Timeout Mismatch" - are all my work.
>> The other three pages were already there, but I moved them here because
>> I felt they belonged here.
>>
>> Please feel free to criticize it (or offer bouquets :-), and give advice
>> as how to improve things, either in private email or on the list.
> 
> Replying to myself, but I'm reasonably happy with the first three
> sections in "When Things Go Wrogn". But it's important that they're
> correct! Would a couple of experts mind looking them over and sending a
> critique to the list? Just a simple "Looks good" would be great and set
> my mind at rest that I have understood things properly and I'm not
> giving out bad advice.
> 
> Note that the next section is going to be along the lines of "My array
> won't assemble / run"
> 
> https://raid.wiki.kernel.org/index.php/Asking_for_help

"smartctl --all" doesn't report ERC settings.  --xall is required, or
for a somewhat shorter report, I find "smartctl -H -i -l scterc" ideal.

> https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

Very good.

> https://raid.wiki.kernel.org/index.php/Replacing_a_failed_drive

You should note that USB connections are not suitable for permanent use.
 Copying a drive or doing a --replace, fine, but don't leave it set up
that way.  USB disconnects, even if only for sleep, will scramble the MD
code.

Also, any time ddrescue is used, the unreadable sectors are replaced
with zeros and there is no longer any indication that that sector is
bad.  That means assembling an array from ddrescued components will
certainly have some corrupt spots.  fsck is mandatory, and there may be
corrupt file content.  ddrescue is only appropriate if there's no
redundancy left in the array to use to fix UREs.

Overall, very good.

Phil


