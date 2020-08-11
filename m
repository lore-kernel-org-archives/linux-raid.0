From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Recommended filesystem for RAID 6
Date: Wed, 12 Aug 2020 01:13:40 +0500
Message-ID: <20200812011340.609e378f@natsu>
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
        <20200811212305.02fec65a@natsu>
        <ea7232af-a411-6b16-d03e-6b21c14cc5be@thelounge.net>
        <20200812003305.6628dd6e@natsu>
        <e662446e-33e4-81fa-18ab-516fd140d51a@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e662446e-33e4-81fa-18ab-516fd140d51a@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: Reindl Harald <h.reindl@thelounge.net>, George Rapp <george.rapp@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 11 Aug 2020 21:49:07 +0200
Rudy Zijlstra <rudy@grumpydevil.homelinux.org> wrote:

> >> no raid can replace backups anyways
> > All too often I've seen RAID being used as an implicit excuse to be lenient
> > about backups. Heck, I know from personal experience how enticing that can be.
> Is the backup not automatic? in that case it is no backup.

Sure it's automatic, by lenient I meant starting to exclude parts of their
data set from being backed up, deciding what is "important" and what is not,
and for the latter portion just hoping for the best because "it is RAID after
all, I can lose TWO drives, what could possibly go wrong". And then something
goes wrong, and it turns out even the data that was "not important" is actually
important enough to warrant scrambling for how to recover it, because
reobtaining it turns out to be costly / huge effort / not actually possible
even if they thought it will be.

> You have simply chosen a different set of mistakes to make. Considering 
> you need to update the "what is where" list regularly (is that 
> automated?)

Of course. In fact I'd suggest keeping similar lists no matter which storage
setup you run. One thing worse than losing data, is losing data *and* not
remembering what you had on there in the first place :)

-- 
With respect,
Roman
