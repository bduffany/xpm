import css from './index.module.css';

export default function Home() {
  return (
    <>
      <div className={css.bigXContainer}>
        <div className={css.bigX}>
          <div className={css.bigX1} />
          <div className={css.bigX2} />
        </div>
      </div>
      <div className={css.card}>
        <div className={`${css.title} ${css.cardRow}`}>xpm</div>
        <div className={`${css.cardRow}`}>
          Install any software on any platform, all from the command line.
        </div>
        <div className={css.term}>
          <pre>
            <span className={css.comment}># get xpm</span>
            <br />
            <span className={css.ps1}>$ </span>curl -sSLo-
            https://xpm.sh/setup.sh | bash
            <br />
            <span className={css.comment}>
              # Install your favorite software.
              <br /># (You won't find these with apt-get!)
              <br />
            </span>
            <span className={css.ps1}>$ </span>xpm install google-chrome ngrok
            fzf
          </pre>
        </div>
        <div className={css.cardRow}>
          <a href="https://github.com/bduffany/xpm">Check it out on GitHub</a>
        </div>
      </div>
    </>
  );
}
