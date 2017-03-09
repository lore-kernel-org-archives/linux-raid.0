From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: Auto replace disk
Date: Wed, 8 Mar 2017 20:08:01 -0600
Message-ID: <CACsGCyTKzHb7Z+2jFPyKiShTf9HSeJvc_9x9mPZY6sNzpaEc_Q@mail.gmail.com>
References: <CAJH6TXgyOEE5A8TZVZy-db+tPD1QeHtnXXO3B-1vmKe4cAt6xA@mail.gmail.com>
 <58C04AC9.9070801@youngman.org.uk> <CAJH6TXjjjnQ3_OJ87Gv8Spsd=7BZ7RGrfCJ0kqeRXTQN_1Q3KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXjjjnQ3_OJ87Gv8Spsd=7BZ7RGrfCJ0kqeRXTQN_1Q3KQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 8, 2017 at 3:32 PM, Gandalf Corvotempesta
<gandalf.corvotempesta@gmail.com> wrote:
>> The last resort is to remove the broken drive and then replace it - this is
>> likely to trigger further failures and bring down the array.
>
> Why ? I've removed many, many, many disks before with no issue.
> Why removing a disk should bring the whole array down? This seems a bug to me.

In a perfect world where you do scrubbing and your timeouts are
properly configured and your other disks are all in good shape, you're
right.  In the real world where people often don't do what, where
multiple bad sectors accumulate on multiple disks before you get a
failure, or where you're just unlucky, a rebuild triggered by removing
a bad disk and adding back a new one has a fair chance of experiencing
a failure during the rebuild.

If you've lost all redundancy due to a disk failure and while doing a
rebuild you experience another read failure or a second disk failure,
whether due to negligence or bad luck, you can lose the whole array.
If you have the option of doing so, therefore, better to --replace
while you still have redundancy.

           Eddie
