From: Song Liu <songliubraving@fb.com>
Subject: [LSF/MM TOPIC] (again) THP for file systems
Date: Wed, 13 Feb 2019 22:00:10 +0000
Message-ID: <77A00946-D70D-469D-963D-4C4EA20AE4FA@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <D311F68F799EF74789524BC7643BD169@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
List-Id: linux-raid.ids

Hi,

I would like to attend the LSF/MM Summit 2019. I'm interested in topics abo=
ut
BPF, mdraid, and MM. I am a designated reviewer of BPF. I am also helping J=
ens
organize mdraid patches.

I would like to discuss remaining work to bring THP to (non-tmpfs) file sys=
tems.
This topic has been discussed multiple times in previous LSF/MM summits [1]=
[2].
However, there hasn't been much progress since late 2017 (the latest work I=
 can
find is by Kirill A. Shutemov [3]).

We (Facebook) uses THP in many services. We see significant savings by putt=
ing
hot-text on THP. To achieve this with state-of-the-art Linux Kernel, we hav=
e to
either: trick the Kernel to believe certain region is anonymous pages; or p=
ut
the executable in tmpfs. In our case, the tmpfs solution is too expensive.
Therefore, we use a hack to trick the Kernel. This hack breaks other useful
features, e.g. perf symbols and uprobes. Instead of introducing more hacks =
to
use these broken features, it is better to enable THP for file systems.
Therefore, we would like discuss (for one more time) what is needed to brin=
g
THP to file systems like ext4, xfs, btrfs, etc. Once we are aligned on the
direction, we are more than happy to commit time and resource to make it ha=
ppen.

Since this topic is my main focus of this year's summit, I would like an in=
vite
to the MM track.

Thanks,
Song

[1] https://lwn.net/Articles/686690/
[2] https://lwn.net/Articles/718102/
[3] https://kernel.googlesource.com/pub/scm/linux/kernel/git/kas/linux/+/hu=
geext4/wip=
