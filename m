From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Is this expected RAID10 performance?
Date: Sun, 09 Jun 2013 20:11:06 -0400
Message-ID: <51B5199A.1050001@gmail.com>
References: <CAO9HMNHVNQcU=FumFnLRd9b0msMr8fr0z6SmL82dksu+6CNXYA@mail.gmail.com> <51B47088.4000501@redhat.com> <CAO9HMNHPeXiMmXYtPb29Y2xiOFpznzmP8nBSV09UFCnMrYkEgQ@mail.gmail.com> <51B4F640.4030605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B4F640.4030605@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Steve Bergman <sbergman27@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/09/2013 05:40 PM, Ric Wheeler wrote:
> On 06/09/2013 04:06 PM, Steve Bergman wrote:

[...]

>> a quick find/fgrep doesn't reveal any usage of fsync at all in any of
>> the ".py" files which ship with the distro. Perhaps the Python VM
>> invokes it automatically? Strace says no. And this is in an enterprise
>> distro which clearly states in its Administrator Manual sections on
>> Ext4 & XFS that you *must* use fsync to avoid losing data. I haven't
>> checked Ruby or Perl, but I think it's a pretty good guess that I'd
>> find the same thing.
>
> I don't know any details about Python, Ruby or Perl internals, but will
> poke around. Note that some of the standard libraries they call might
> also have buried calls in them to do the write thing with fsync() or
> fdatasync().

Perl's IO layer is tunable using various "personalities" you can invoke 
at module load, file open, on file descriptors, etc.  The syncs are in 
the standard library.  This said, a number of the distro Perl's are 
badly horribly broken (or out of date and EOLed for years now ... cough 
cough).  Python has similar capability, and its IO layer is usually a 
direct pass through to the underlying library calls.  You can force sync 
on IO, though most sane programmers won't do that.

