From: Bhatia Amit <amitbhatia@rocketmail.com>
Subject: Re: Cannot start array on disk
Date: Sat, 23 Jul 2016 22:47:22 +0000 (UTC)
Message-ID: <330476394.3563695.1469314042611.JavaMail.yahoo@mail.yahoo.com>
References: <1124605843.526681.1468785592654.JavaMail.yahoo.ref@mail.yahoo.com> <1124605843.526681.1468785592654.JavaMail.yahoo@mail.yahoo.com> <73583e52-ca6b-b043-cbae-02c8a122be24@turmel.org> <1436537429.1672198.1468980612541.JavaMail.yahoo@mail.yahoo.com> <1537154003.1687848.1468983169996.JavaMail.yahoo@mail.yahoo.com> <6b958d9f-ec61-3b87-fcd7-ff63c0af32fe@turmel.org> <1334935791.2305089.1469066429563.JavaMail.yahoo@mail.yahoo.com> <48687c4e-792c-7cdc-7374-3020964f1892@turmel.org> <1152956900.3399623.1469246417006.JavaMail.yahoo@mail.yahoo.com> <b151a240-c3a4-3b59-0ba5-b6ac5776a16d@turmel.org> <578225037.3489302.1469312496573.JavaMail.yahoo@mail.yahoo.com> <bc8e09fe-c489-e85d-bb8a-c3c9ff0b9588@turmel.org>
Reply-To: Bhatia Amit <amitbhatia@rocketmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bc8e09fe-c489-e85d-bb8a-c3c9ff0b9588@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids




> The old and new data are completely different filesystems, I believe.
> And I suspect the folder data for the latter half of the disk is in the
> (missing) first half of the disk.  Certainly the root folder.  If

> r-linux can recover file contents, that's better than I've got.  I doubt
> you have any folder data for the new < half disk.
>
> > In an earlier email, you had suggested possibly running fsck on sdc4
> > partition. Is that something I should be considering?
>
> No, I don't believe it can handle anything like this.  You might want to
> share this thread with the ext4 list.


Hi Phil


I think I understand the issue you are describing here. Also, I will share this thread with the ext4 list to get their suggestion.

Thanks for the all help.
Amit
