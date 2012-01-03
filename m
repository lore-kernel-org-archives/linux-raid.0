From: Phil Turmel <philip@turmel.org>
Subject: Re: Is this RAID recoverable???
Date: Tue, 03 Jan 2012 10:42:29 -0500
Message-ID: <7256bd68-866f-40d8-8baf-ae3afe8ec4db@email.android.com>
References: <CAHw_BJ3fGd2ZN5ORs4+DSxz57AhT6jq7oL+cs_4MaztZX0sgUQ@mail.gmail.com> <20120103153757.5487e6fa@natsu> <4F0301F0.40206@turmel.org> <CAHw_BJ3qH+BgAxY3PHFUU_CH2EDf88xvn6V=rV71fzA-xUcLvw@mail.gmail.com> <4F0311EF.9010102@turmel.org> <CAHw_BJ0NEd_RHQqdONkTiq4HO2RWQD3uHUAbQvqca9OGapgmEg@mail.gmail.com> <CAHw_BJ26omrNdOzc23mCF5ObEG9z8zwmNFrP5h2dkfg_Pj+BNQ@mail.gmail.com> <4F031C43.6030601@turmel.org> <CAHw_BJ2Zzivi25zDvd6zj6=85mKRNExEiUgy8HmHVk94mn_FoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHw_BJ2Zzivi25zDvd6zj6=85mKRNExEiUgy8HmHVk94mn_FoQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Richter <iamcomcy@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Paul,

[You top-posted again...]

Paul Richter <iamcomcy@gmail.com> wrote:

>So, I should DD back up the whole thing before trying to reconstruct.

The create operation with v2.6.9 isn't any more dangerous than the create operations already done.

>If the reconstruct is successful, then I build a new array and copy
>everything from the old to the new, right?

When/if the recreate succeeds, do a filesystem backup, recreate the array again, and restore.

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
