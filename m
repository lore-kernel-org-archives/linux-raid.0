From: <ian_bruce@mail.ru>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component
 devices
Date: Fri, 24 Feb 2017 08:40:24 -0800
Message-ID: <20170224084024.4dfe83a2.ian_bruce@mail.ru>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
        <41ea334c-ae1c-dac6-e1a1-480d3700a588@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41ea334c-ae1c-dac6-e1a1-480d3700a588@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 24 Feb 2017 10:20:52 -0500
Phil Turmel <philip@turmel.org> wrote:

> Considering the existence of --build is strictly to support arrays
> that predate MD raid, it seems a bit of a stretch to claim this as a
> bug instead of a feature request.

quoting from the mdadm manual page:

    *Build*
    
    Build an array that doesn't have per-device metadata (superblocks).
    For these sorts of arrays, mdadm cannot differentiate between
    initial creation and subsequent assembly of an array. It also cannot
    perform any checks that appropriate components have been requested.
    Because of this, the Build mode should only be used together with a
    complete understanding of what you are doing.

No mention of "arrays that predate MD RAID" there. Nor any mention of a
27-component limit, either. Nor does the eventual error message mention
any such thing (although "mdadm --create --metadata=0 --raid-devices=28"
does). I'd call that a bug.

Since there's no pre-existing superblock, and the kernel has to create
one, it could just as easily use the v1.2 format as the v0.90 format, as
it does with "mdadm --create". Why shouldn't the v1.2 format be the
default for "mdadm --build" as well? That would be more consistent --
why should these two options behave differently in this regard, in the
absence of any material reason to do so?

--create : initialize v1.2 kernel superblock and write to disk

--build  : initialize v1.2 kernel superblock but don't write to disk

It seems like it would actually be simpler to treat the two cases the
same, rather than differently.


-- Ian Bruce
