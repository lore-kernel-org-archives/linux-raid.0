From: Song Liu <song@kernel.org>
Subject: Re: [song-md:md-next 9/14] ERROR: modpost: "__udivdi3" undefined!
Date: Wed, 22 Jul 2020 14:31:00 -0700
Message-ID: <CAPhsuW66LPe0feQtgns=Tp2JYvUNT6vDnqg6j1inq+WT8uQrsQ@mail.gmail.com>
References: <202007230512.Ql0lYtJc%lkp@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <202007230512.Ql0lYtJc%lkp@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: kernel test robot <lkp@intel.com>
Cc: Yufen Yu <yuyufen@huawei.com>, kbuild-all@lists.01.org, linux-raid <linux-raid@vger.kernel.org>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

On Wed, Jul 22, 2020 at 2:21 PM kernel test robot <lkp@intel.com> wrote:
>
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
> head:   fe630de009d0729584d79c78f43121e07c745fdc
> commit: e236858243d7a8e0ac60972d2f9522146088a736 [9/14] md/raid5: set default stripe_size as 4096
> config: m68k-sun3_defconfig (attached as .config)
> compiler: m68k-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout e236858243d7a8e0ac60972d2f9522146088a736
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=m68k
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>, old ones prefixed by <<):
>
> >> ERROR: modpost: "__udivdi3" [drivers/md/raid456.ko] undefined!

Yufen, could you please look into this one? I guess it is caused by ilog2().

Thanks,
Song
