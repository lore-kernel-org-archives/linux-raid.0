From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH 1/2] mdadm/manpage:update description for readonly in
 manpage
Date: Tue, 11 Apr 2017 17:30:25 +0100
Message-ID: <58ED04A1.4010508@youngman.org.uk>
References: <1491811296-9118-1-git-send-email-zlliu@suse.com>
 <1491811478-9234-1-git-send-email-zlliu@suse.com>
 <6afe1397-3063-c5d7-58ba-f3dbdfa05336@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6afe1397-3063-c5d7-58ba-f3dbdfa05336@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/04/17 15:51, Jes Sorensen wrote:
>>
>>  .TP
>>  .B \-\-readonly
>> -This will mark an active array as read-only, providing that it is
>> -not currently being used.
>> +This will set an active array as read-only status.
> 
> I think this chance is not good, and should be omitted.

Agreed, except that I would change "providing" to "provided".
> 
>>  .TP
>>  .B \-\-readwrite
>> -This will change a
>> +This will change an
>>  .B readonly
>>  array back to being read/write.
> 
> This change is grammatically incorrect I believe and the original text
> is correct.

Agreed.

Cheers,
Wol
