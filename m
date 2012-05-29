From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 4/4] Move setup code to a function and introduce matching
 cleanup argument
Date: Tue, 29 May 2012 08:02:16 +0200
Message-ID: <4FC46668.9070306@redhat.com>
References: <1337959448-5299-1-git-send-email-Jes.Sorensen@redhat.com> <1337959448-5299-5-git-send-email-Jes.Sorensen@redhat.com> <20120528105641.7dd20b5f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120528105641.7dd20b5f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/28/12 02:56, NeilBrown wrote:
> On Fri, 25 May 2012 17:24:08 +0200 Jes.Sorensen@redhat.com wrote:
> 
>> @@ -231,7 +233,7 @@ do_test() {
>>      if [ "$savelogs" == "1" ]; then
>>        cp $targetdir/log $logdir/$_basename.log
>>      fi
>> -    if [ "$_fail" == "1" -a $"exitonerror" == "1" ]; then
>> +    if [ "$_fail" == "1" -a "$exitonerror" == "1" ]; then
>>        exit 1
>>      fi
>>    fi
> 
> I merged this fix back into the previous patch that introduced the bug :-)
> 
> Otherwise - all applied,
> Thanks.

Sounds good!

> I'll definitely be using the --no-error option!

Excellent, glad it's turning out to be useful. I am trying to get to a
point where I can have the test suite run automatically, though I am
still hitting test errors on both Fedora and RHEL at this point which I
need to figure out first.

Cheers,
Jes
