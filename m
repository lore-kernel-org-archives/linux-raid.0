From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Converting system to raid
Date: Sat, 11 Apr 2009 10:50:35 +0200
Message-ID: <87y6u7o9pg.fsf@frosties.localdomain>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg>
	<20090410132233.GA15442@cthulhu.home.robinhill.me.uk>
	<008001c9ba12$3ac92c10$0a00a8c0@vorg>
	<20090410195006.GA21242@cthulhu.home.robinhill.me.uk>
	<Pine.LNX.4.61.0904110035420.6312@soloth.lewis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0904110035420.6312@soloth.lewis.org> (Jon Lewis's
	message of "Sat, 11 Apr 2009 00:40:37 -0400 (EDT)")
Sender: linux-raid-owner@vger.kernel.org
To: Jon Lewis <jlewis@lewis.org>
Cc: Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Lewis <jlewis@lewis.org> writes:

> On Fri, 10 Apr 2009, Robin Hill wrote:
>
>> On Fri Apr 10, 2009 at 12:22:44PM -0700, Timothy D. Lenz wrote:
>>
>>> How can cp not work? every guide I found used ether cp or rsync. Even
>>> guides on seting up an auto backup system use cp or rsync.
>>> Seems the only files/folders that shouldn't get copied are the block
>>> device ones that are created at boot and are not really on the drive.
>>>
>> They'll all get copied, but you won't necessarily get the correct
>> contents.  Because the system is in use:
>> - files will be being written, so you'll either get a partial copy, or
>>   an old version.
>> - files may be locked, so you won't be able to copy them.
>>
>> Doing a backup of a running system using cp/rsync will work fine for a
>> lot of things (especially for config files, documents, etc) but will
>> almost certainly fail miserably for some (databases for example).

What one can easily do is rsync the running system, then init 1 and
rsync again to get all the changed or blocked files. In runlevel 1
there should be nothing left blocking files.

MfG
        Goswin
