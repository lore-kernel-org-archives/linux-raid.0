From: David Greaves <david@dgreaves.com>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Tue, 04 Jan 2005 14:15:44 +0000
Message-ID: <41DAA510.4060202@dgreaves.com>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es> <16857.64086.362458.177296@cse.unsw.edu.au> <6d5bedd80501031816eb8f296@mail.gmail.com> <16857.65024.745883.752981@cse.unsw.edu.au> <20050104024108.GK99565@caffreys.strugglers.net> <16858.4291.816499.371678@cse.unsw.edu.au> <0h5qa2-0qa.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0h5qa2-0qa.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:

>>ext3 journals are much safer on mirrored devices than on non-mirrored
>>    
>>
>That's irrelevant - you don't care what's in the journal, because if
>your system crashes before committal you WANT the data in the journal
>to be lost, rolled back, whatever, and you don't want your machine to
>have acked the write until it actually has gone to disk.
>
>Or at least that's what *I* want. But then everyone has different
>wants and needs. What is obvious, however, are the issues involved.
>  
>
err, no.

If the journal is safely written to the journal device and the machine 
crashes whilst updating the main filesystem you want the journal to be 
replayed, not erased. The journal entries are designed to be replayable 
to a partially updated filesystem.

That's the whole point of journalling filesystems, write the deltas to 
the journal, make the changes to the fs, delete the deltas from the journal.

If the machine crashes whilst the deltas are being written then you 
won't play them back - but your fs will be consistent.

Journaled filesystems simply ensure the integrity of the fs metadata - 
they don't protect against random acts of application/user level 
vandalism (ie power failure).

David
